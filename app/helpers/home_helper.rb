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

  def current_usage
    v=`vnstat -i eth0 --oneline`
    mtu=v.split(';')[10] if !v.nil?
  end

  def estimated_usage
    v=`vnstat -i eth0 -m`
    mtu=v.lines.last.split('|')[2] if !v.nil?
  end
end
