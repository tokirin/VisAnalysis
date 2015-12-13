class AnalyticsController < ApplicationController
  layout 'analytics'
  before_action :init
  def show

  end

  private

  def init
    @data = DataSet.find(params[:id])
    @data_name = @data.data_name
    @headers = @data.headers
    @cols = @data.columns
    @rows = @data.rows
    @data_id = params[:id]

    @correlation_result = @data.correlation_analysis
  end


end
