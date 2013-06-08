module HomeHelper
  def chart_tag (action, params = {})
    params[:format] ||= :json
    params[:height] ||= '300'

    path = graph_path(action, params)
    content_tag(:div, :'data-chart' => path, :style => "height: #{params[:height]}px;") do
      content_tag(:div, :class => "center") do
        content_tag(:i, :class => "icon-spinner icon-spin icon-3x muted") { }
      end
    end
  end

  def current_usage oneline
    oneline.split(';')[10] if !oneline.nil?
  end

  def estimated_usage raw_months
    raw_months.lines.last.split('|')[2] if !raw_months.nil?
  end
end
