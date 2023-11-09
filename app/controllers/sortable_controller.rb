##
# Copy of {{SortableController}} from the sortable gem to overwrite
class SortableController < ApplicationController
  skip_authorization_check

  VERIFIER = Rails.application.message_verifier(:rails_sortable_generate_sortable_id)

  ##
  # Records movement in drag and drop ordering of tables
  def reorder
    ActiveRecord::Base.transaction do
      params['rails_sortable'].each_with_index do |token, new_sort|
        next unless token.present?

        model = find_model(token)
        current_sort = model.read_attribute(model.class.sort_attribute)
        model.update_sort!(new_sort) if current_sort != new_sort
      end
    end

    head :ok
  end

  private

  def find_model(token)
    klass, id = VERIFIER.verify(token).match(/class=(.+),id=(.+)/)[1..2]
    klass.constantize.find(id)
  end
end
