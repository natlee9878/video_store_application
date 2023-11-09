##
# Provides function for generating labels of various kind for rendering in views.
module LabelHelper
  def controller_label(key = controller_name)
    t("title.#{key}", default: key.humanize.titleize)
  end

  def list_show_link(object)
    return unless can?(:read, (object.is_a?(Array) ? object.last : object))

    link_to(
      content_tag(:i, '', class: 'icon-search'),
      object,
      class: 'btn btn-mini btn-info'
    )
  end

  ##
  # @param object [ActiveRecord::Base] an ActiveRecord object to be edited
  # @param options [Hash] options Hash
  # @options options [Boolean] :quick edit (default = false) pass this true if you want the edit
  #   link to open a quick edit form.
  # @return [String, nil] HTML for an link to edit object, or, if user does not have permission to
  #   update object, returns nil
  def list_edit_link(object, options = { quick_edit: false })
    return unless can?(:update, object)

    link_to(
      content_tag(:i, '', class: 'icon-pencil'),
      [:edit, object],
      class:
        "btn btn-mini btn-warning#{
            ' quick-edit-open' if options[:quick_edit]
          }"
    )
  end

  def list_destroy_link(object)
    return unless can?(:delete, (object.is_a?(Array) ? object.last : object))

    link_to(
      content_tag(:i, '', class: 'icon-trash'),
      object,
      class: 'btn btn-mini btn-danger',
      method: :delete,
      data: { confirm: 'Are you sure you want to delete this record?' }
    )
  end

  ##
  # Set a boolean label for boolean with text based on human representation
  # @param value (Boolean)
  # @param text (String)
  # @return (HTML)
  def boolean_label(value, text = nil)
    if value
      content_tag(
        :span,
        text.presence || 'Yes',
        class: 'badge badge-success'
      )
    else
      content_tag(:span, text.presence || 'No', class: 'badge badge-secondary')
    end
  end

  ##
  # @param value [Boolean] truthy to return a tick, or falsey to return a cross
  # @return [String] HTML that appears as a tick or a cross, to indicate a boolean value
  def check_or_cross(value)
    content_tag(:span) do
      content_tag(:i, '', class: "icon-large #{value ? 'icon-ok success-icon' : 'icon-remove error-icon'}")
    end
  end

  def status_label(record)
    raw(
      if record.active
        '<span class="badge badge-success">Active</span>'
      else
        '<span class="badge badge-secondary">Inactive</span>'
      end
    )
  end
end
