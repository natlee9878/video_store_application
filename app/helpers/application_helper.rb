module ApplicationHelper
  ##
  # Format the phone number based on e164 format based on country code
  # @param phone (String)
  # @return (String)
  def phone_format(phone)
    return if phone.blank?

    parsed = Phonelib.parse(phone)
    phone =  parsed.international
    phone = parsed.national if parsed.country == Phonelib.default_country.presence
    phone
  end

  def sort_column_link(collection, key, text = nil, &block)
    new_params = params.dup.permit!
    new_params.delete(:page)
    new_params[:sort] = key

    link_options = { remote: true }
    link_options[:style] = 'display: inline-block;'
    link_options[:class] = 'js-partial-refresh'

    if collection && !collection.valid_sort_option?(key)
      raise ArgumentError, "Unknown sort_option \#{key.to_s.inspect} for \#{collection.model_name}"
    end

    # We get the current sorting info from the collection, rather than
    # params, so we know what's going on when the params don't say
    # anything, and the default order has been applied.
    current_sort, current_reverse = collection && collection.respond_to?(:last_user_sort) && collection.last_user_sort
    if block_given?
      raise ArgumentError, "Can't supply a string and a block" unless text.nil?

      text = capture(&block)
    else
      text ||= collection.human_attribute_name(key)
    end

    if current_sort == key.to_s
      new_params[:reverse_order] = if new_params[:reverse_order].to_s == 'true' || current_reverse
                                     false
                                   else
                                     true
                                   end
      current_dir = current_reverse ? 'desc' : 'asc'
      link_to(text, new_params, link_options.merge(data: { current: current_dir }))
    else
      link_to(text, new_params, link_options)
    end
  end

  def flash_class(type)
    case type
    when :notice then 'alert-info'
    when :info then 'alert-info'
    when :alert then 'alert-error'
    when :warning then 'alert-warning'
    else ''
    end
  end

  ##
  # Check whether asset is available in public folder or asset folder before rendering
  # @return (Boolean)
  def asset_exists?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end

  def merge_html_classes(value1, value2)
    [value1, value2].flatten.compact
  end

  def portlet(title, options = {}, &block)
    portlet_html = options[:portlet_html] || {}
    portlet_html[:class] = ['portlet clear-fix', portlet_html[:class]]
    portlet_html[:data] ||= {}
    portlet_html[:data][:source] = options[:source] unless block_given?

    heading_html = options.delete(:heading_html) || {}
    heading_html[:class] = merge_html_classes('portlet-heading', heading_html[:class])

    body_html = options.delete(:body_html) || {}
    body_html[:class] = merge_html_classes('portlet-body clear-fix', body_html[:class])

    if options[:icon]
      icon = content_tag(:i, nil, class: "portlet-heading-icon fa fa-fw fa-#{options[:icon].to_s.dasherize}")
    end

    # This determines if the portlet can be closed. If it is remote it can be closed. If not,
    # it is determined by the presence of expand in the options.
    # e.g. <%= portlet 'A title', expand: true do %>...
    closable = options.key?(:source) || options.key?(:expand)

    portlet_html[:data][:closable] = closable

    controls_content = ''.html_safe
    controls = options.delete(:controls)
    if controls.present?
      if controls.respond_to?(:each)
        controls.each do |control|
          controls_content << content_tag(:span, control, class: 'portlet-control-item')
        end
      else
        controls_content << content_tag(:span, controls, class: 'portlet-control-item')
      end
    end

    controls_content << content_tag(:span, nil, class: 'portlet-indicator') if closable

    controls_wrapper = content_tag(:div, controls_content, class: 'portlet-controls') if controls_content.present?

    # This determines if the portlet should be expanded by default. If it is explicitly given that
    # takes precedence. If not, by default all remote portlets are not expanded and all static
    # portlets are.
    expand = options.key?(:expand) ? options[:expand] : block_given?

    if expand
      portlet_html[:class] << 'expanded'
      portlet_html[:data][:expand] = true
    end

    heading_content = content_tag(:div, heading_html) do
      (icon || ''.html_safe) + content_tag(:h4, title) + (controls_wrapper || ''.html_safe)
    end

    body_content = content_tag(:div, (capture(&block) if block_given?), body_html)

    content_tag(:div, portlet_html) do
      heading_content + body_content
    end
  end

  ##
  # returns file name with fontawesome icon based on the file type
  # @params [File Object]
  # @returns [String]
  def file_icon(file, display_name = true, uploader_column = 'file')
    return unless file.try(:file).present?

    extension = file.send(uploader_column).extension
    file_name = file.send(uploader_column).path.split('/').last

    icon =
      case extension
      when 'pdf'
        'fa-file-pdf'
      when 'jpg', 'png', 'svg'
        'fa-file-image'
      when 'txt'
        'fa-file-text'
      when 'doc', 'docx'
        'fa-file-word'
      when 'xls', 'xlsx'
        'fa-file-excel'
      when 'csv'
        'fa-file-csv'
      else
        'fa-file'
      end

    url = file.send(uploader_column).respond_to?(:url) ? file.send(uploader_column).url : file.url

    "<a target='_blank' href='#{url}'><i class='fa #{icon}' aria-hidden='true' title='#{file_name}'></i> #{
        file_name if display_name
      }</a>"
  end

  def collection_display(collection, uploader_column)
    display = collection.map do |a|
      if a.send(uploader_column).present?
        if a.send(uploader_column).file.content_type.to_s.include?('image')
          link_to(image_tag(a.send(uploader_column).thumb.url, title: a.send(uploader_column).identifier),
                  a.send(uploader_column).url, target: '_blank')
        else
          file_icon(a.send(uploader_column), false)
        end
      end
    end

    "<span class='collection-preview'>#{display.join(' ')}</span>"
  end

  ##
  # Formats param to either titlized string or date
  # @param [String] || [Date] || [Integer] || [Boolean]
  # @param [String]
  # @return [String] || [Money Object]
  def format_detail_value(value, input)
    return unless value.present?

    # needed as .to_date was valid on these strings when this was not desired
    formatted_value = begin
      if %w[day_of_month day_of_next_month business_days calendar_days]
         .include?(value)
        nil
      else
        value.to_date
      end
    rescue StandardError
      nil
    end

    if formatted_value.nil?
      if value.is_a?(Integer)
        if input.include?('_id')
          # TODO: Handle any ids here
        else
          input.include?('_cents') ? humanized_money_with_symbol(Money.new(value)) : value
        end
      else
        value.to_s.titleize
      end
    else
      formatted_value
    end
  end

  ##
  # Builds a string based on the change that has occurred
  # @param [Array]
  # @return [String]
  def build_history_string(change)
    if change.last['old'].present?
      if change.last['new'].blank?
        "<b>#{ change.first.gsub('_cents', '')
          .titleize }</b> was cleared from a previous value of <i>#{ format_detail_value(change
          .last['old'], change.first) }</i><br/>"
      else
        "<b>#{ change.first.gsub('_cents', '')
          .titleize }</b> was changed from <i>#{ format_detail_value(change
          .last['old'], change.first) }</i> to <i>#{format_detail_value(change.last['new'], change.first)}</i><br/>"
      end
    else
      "<b>#{ change.first.gsub('_cents', '')
        .titleize }</b> was set to <i>#{format_detail_value(change.last['new'], change.first)}</i><br/>"
    end
  end

  ##
  # Builds an array of changes between two versions
  # @param [Object]
  # @param [Integer]
  # @return [Array]
  def changes(versioned_history, i)
    changes = []
    versioned_history.diff_from(version: i - 1)['changes'].each do |change|
      unless change.first == 'updated_at'
        string = build_history_string(change)
        changes.push(string)
      end
    end
    changes
  end

  ##
  # checks if this is the active menu item
  # @param [String]
  # @return [Boolean]
  def active_navigation?(path)
    request.path.start_with?("#{path}")
  end

  ##
  # Method to make current menu navigation show as active
  # @param controller_name[String]
  # @param options[Hash]
  # @return [String]
  def is_active_controller(controller_name, options: nil)
    class_name = options[:class_name].to_s if options.present?
    action_name = options.present? ? options[:action_name].to_s : 'index'

    current_controller = params[:controller]&.gsub('admin/', '')&.parameterize&.underscore
    current_controller == (controller_name&.parameterize&.underscore || class_name) && (params[:action] == action_name) ? 'active' : nil
  end

  ##
  # To set gray color on selection if selection is inactive but chosen by user
  # @param list (Hash[])
  # @param current_selection (Object(s))
  # @param type (String)
  # @param text_method (String)
  # @param value_method (String)
  # @return (Array[])
  def select_list(list, current_selection, type, text_method = 'to_s', value_method = 'id')
    if type == 'enum'
      select = list.map { |x| [x.text, x.to_s] }
      return select if current_selection.blank?

      current_selection =
        if [current_selection].to_a.flatten.count == 1 || current_selection.is_a?(String)
          [current_selection.to_s]
        else
          current_selection.to_a
        end
      current_selection.to_a.each do |selection|
        next if list.map(&:to_s).include?(selection)

        select =
          select.unshift(
            [
              selection.titleize,
              selection,
              { disabled: true, selected: true }
            ]
          )
      end
    elsif type == 'references'
      current_selection =
        if current_selection.is_a?(ActiveRecord::Base)
          [current_selection]
        else
          current_selection.to_a
        end

      max_count = ENV['LIST_MAX_RECORDS'].to_i
      if list.count > (max_count > 0 ? max_count : 50)
        return current_selection.map { |x| [x.send(text_method), x.send(value_method)] }
      end

      select = list.map { |x| [x.send(text_method), x.send(value_method)] }
      return select if current_selection.blank?

      current_selection.to_a.each do |selection|
        next if list.map(&:id).include?(selection.id)

        select =
          select.unshift(
            [selection.to_s.titleize, selection.id, { disabled: true, selected: true }]
          )
      end
    else
      select = list
    end

    select
  end

  ##
  # Set a json for select options on inline editing
  # @param object (Object)
  # @param type (String)
  # @param text_method (String)
  # @param allow_nil (Boolean)
  # @return String
  def inline_select_options(object, type, text_method = 'to_s', allow_nil = false)
    if type == 'enum'
      text = object.map { |x| { x.to_s => x.text } }
    elsif type == 'boolean'
      text = object.map { |x| { x[1] => x[0] } }
    elsif type == 'references'
      text = object.map { |x| { x.id => x.send(text_method).to_s } }
    end
    text.unshift({ '' => 'Empty' }) if allow_nil
    text.to_s.gsub('=>', ':')
  end

  ##
  # Returns nested array of enum values grouped by their group title
  # @param list (Hash[])
  def select_grouped_enum(list)
    grouped_options = []
    group_title = ''
    list.each do |e_value|
      if (e_value.grouped_by if defined? e_value.grouped_by)
        if e_value.grouped_by == group_title
          grouped_options.last.last << [e_value.text, e_value.to_s]
        else
          group_title = e_value.grouped_by
          grouped_options << [group_title, [[e_value.text, e_value.to_s]]]
        end
      else
        grouped_options << [nil, [[e_value.text, e_value.to_s]]]
      end
    end
    grouped_options
  end

  ##
  # Returns if the passed file is an image based on it's extension
  # @param file[Object]
  # @param uploader_column[String]
  # @return [Boolean]
  def is_image?(file, uploader_column = 'file')
    if file.try(:file).present?
      extension = file.send(uploader_column).extension
      return true if %w[img image png jpg jpeg gif svg].include?(extension)
    else
      false
    end
  end

  ##
  # Create a list of available token for letter template
  # @param models (Array[])
  # @return (String)
  def template_token(models)
    return if models.blank?

    str = '<div style="padding: 0 10px; height: 300px; overflow: scroll;">'
    models.each do |model|
      liquid = begin
        (model.is_a?(Class) ? model : model.to_s.constantize).new.to_liquid
      rescue StandardError
        nil
      end
      next unless liquid.present?

      tokens = (liquid.public_methods - Liquid::Drop.new.public_methods).map(&:to_s)
      tokens.each do |token|
        if liquid.respond_to?("#{token}_description".to_sym, true)
          str << "<b>{{#{model.to_s.underscore}.#{token}}}:</b> #{
          liquid.send("#{token}_description".to_sym)}<br/>"
        end
      end
    end
    str << '</div>'
  end

  ##
  # Converts unhandled mimetypes from file content types
  # @param type[String]
  # @return [String]
  def file_config_type(type)
    case type
    when 'svg+xml'
      'svg'
    else
      type
    end
  end
end

def boolean_label(value, human_readable)
  if value
    content_tag :span, human_readable, class: 'badge badge-success'
  else
    content_tag :span, human_readable, class: 'badge badge-danger'
  end
end