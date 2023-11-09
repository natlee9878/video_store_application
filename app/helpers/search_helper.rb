module SearchHelper
  ##
  # Renders the table filters form to the view.
  # @param path (String) the path for the form_tag
  # @param options (Hash) all options that can be passed to form_tag are respected here.
  # @yield The contents for the table filters
  def table_filters(path, options = {}, &block)
    options[:class] =
      merge_html_classes(
        'filter-form inline-query table-filters js-partial-refresh clear-fix',
        options[:class]
      )

    options[:remote] = false || options[:remote]
    options[:method] ||= :get

    content = capture(&block)

    return unless content

    form_tag path, options do
      content
    end
  end

  ##
  # Renders a table filter item to the view.
  # @param attribute (String, Symbol)
  # @param options (Hash)
  # @options options (Symbol) :type the type of field to display
  # @options options (Hash) :options the select options for select inputs
  # @options options (String) :default the default select option for select inputs
  # @options options (Hash) :input_html any data contained within this hash will be passed to
  #   the appropriate *_tag method
  # @options options (Boolean, String) :label the text to display as a label if a string. If false,
  #   this will prevent the label from being shown
  # @options options (Hash) :label_html any data contained within this hash will be passed to
  #   the content_tag builder for the label
  # @yield The contents of the table filter with the label (unless options[:label] is false)
  def table_filter_item(attribute, options = {}, &block)
    if block_given?
      field = capture(&block)
    else
      if attribute == :submit
        content_html = content_tag(
          :div,
          submit_tag('Go', class: 'btn btn-go'),
          class: 'control-wrapper'
        )
        parent_content = content_tag(:div, content_html, class: 'form-group')
        parent_div = content_tag(:div, parent_content, class: 'col-sm-1')
        return parent_div
      end
      type = options.delete(:as) || :string
      extra_class = ''

      # If we're given an options array, we assume it to be a select filter.
      # This allows for more concise code in the form
      #   table_filter_item :status, options: %w(Yes No)
      # or
      #   filter.on :status, options %W(Yes No)
      type = :select if options[:options].present?

      # We define the :active_status type to shortcut a common filter type.
      if type == :active_status
        type = :select
        options[:options] ||= %w[All Active Inactive]
        options[:default] ||= 'Active'
      end

      input_html = options.delete(:input_html) || {}
      input_html[:class] =
        merge_html_classes(
          'form-control',
          input_html[:class]
        )

      # Defaulting to a simple text field, we choose which field to output here.
      # @note if at some point we wish to add a new field type, here is the place to add it
      case type
      when :select
        input_html[:class] = merge_html_classes('select2', input_html[:class])
        options[:options] ||= []
        field =
          select_tag(
            attribute,
            options_for_select(
              options[:options],
              params[attribute.to_sym] || options[:default]
            ),
            input_html
          )
      when :date
        input_html[:class] =
          merge_html_classes('datepicker text-right', input_html[:class])
        input_html[:type] = 'date'
        field = text_field_tag(attribute, params[attribute.to_sym], input_html)
        icon =
          content_tag(:span, nil, class: 'input-addon fa fa-fw fa-calendar')
        field = content_tag(:div, icon + field, class: 'addon-wrapper')
        extra_class = ' datediv'
      when :radio
        options[:collections] ||= []
        options[:value_method] ||= :last
        options[:text_method] ||= :first

        field =
          collection_radio_buttons(
            attribute,
            params[attribute.to_sym] || options[:default],
            options[:collections],
            options[:value_method],
            options[:text_method]
          )
      else
        # :string
        input_html[:placeholder] = 'Type your keyword'
        field = text_field_tag(attribute, params[attribute.to_sym], input_html)
      end
    end

    label = ''.html_safe
    if options[:label] != false
      label_html = options.delete(:label_html) || {}
      if type == :radio
        if label_html[:class].present?
          label_html[:class] += ' collection-label'
        else
          label_html = { class: 'collection-label' }
        end
      end

      label_text = options.delete(:label) || attribute.to_s.titleize
      label = label_tag(attribute, label_text + ': ', label_html)
    end

    if type == :select
      classes = 'form-group'
      options[:size]
      content =
        content_tag(:div, label + field, class: 'control-wrapper').html_safe
      select = content_tag(:div, content, class: classes + extra_class)
      content_tag(
        :div,
        select,
        class:
          "pr0 #{
            options[:size] ? "col-sm-#{options[:size]}" : 'col-sm-2'
          }"
      )
    else
      classes = options[:size] ? "col-sm-#{options[:size]} " : 'col-sm-2'
      classes += ' pr0'

      content =
        content_tag(
          :div,
          label + field,
          class: 'control-wrapper' + "#{' collection-radio' if type == :radio}"
        ).html_safe
      parent_content = content_tag(:div, content, class: 'form-group')
      content_tag(:div, parent_content, class: classes)

    end
  end

  ##
  # Renders a table filters section to the view using the table filter builder DSL.
  # @param resource (ActiveRecord::Base) the model instance to build the table filters for.
  # @param options (Hash) all options that can be passed to content_tag are respected here.
  # @yield The contents of the table filters section
  def filters_for(path, options = {}, &block)
    builder = TableFiltersBuilder.new(self)
    table_filters(path, options) { capture(builder, &block) }
  end

  class TableFiltersBuilder
    ##
    # Creates an instance of TableFiltersBuilder
    # @param helper (ApplicationHelper) instance of application helper to allow access to view helpers.
    # @yield instance of TableFiltersBuilder
    def initialize(helper)
      @helper = helper
    end

    ##
    # Renders a table_filter_item inside the table_filters using a custom DSL.
    #
    # @param attribute (Symbol) the attribute on the resource
    # @param options (Hash) all options that can be passed to content_tag are respected here.
    # @yield The contents of the details panel item
    def on(attribute, options = {}, &block)
      if block_given?
        helper.table_filter_item(attribute, options, &block)
      else
        helper.table_filter_item(attribute, options)
      end
    end

    private

    ##
    # Access view helpers within the details panel builder
    # @yield instance of ApplicationHelper
    attr_reader :helper
  end
end
