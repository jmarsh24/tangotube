# frozen_string_literal: true

class FeaturesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :authenticate_user!
  before_action :set_featureable, only: [:create]

  # @route POST /features (features)
  def create
    @feature = @featureable.features.new(user: current_user)
    if @feature.save
      respond_to do |format|
        format.turbo_stream { ui.replace(dom_id(@featureable, "feature-button"), with: "shared/feature_button", featureable: @featureable) }
        format.html { redirect_to @featureable }
      end
    end
  end

  # @route DELETE /features/:id (feature)
  def destroy
    @feature = current_user.features.find(params[:id])

    featureable = @feature.featureable
    if @feature.destroy
      respond_to do |format|
        format.turbo_stream { ui.replace(dom_id(featureable, "feature-button"), with: "shared/feature_button", featureable:) }
        format.html { redirect_to featureable }
      end
    end
  end

  private

  def set_featureable
    @featureable_type = params[:featureable_type].classify
    @featureable = @featureable_type.constantize.find(params[:featureable_id])
  end
end
