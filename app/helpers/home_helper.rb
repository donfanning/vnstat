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

  def current_usage oneline, device
    if !oneline.nil?
      content_tag :div, :class => "alert alert-warning center" do
        [
          content_tag(:h2, oneline.split(';')[10]), 
          "<p><small>approximate usage so far for #{AVAILABLE_DEVICES[device.to_sym]}</small></p>"
        ].join("").html_safe
      end
    end
  end

  def daily_history history
    results = []
    results << "<table id='daily-history' class='table table-condensed table-striped table-bordered'>
      <thead>
        <tr>
          <th>Date</th>
          <th>Rec MiB</th>
          <th>Trn Mib</th>
          <th>Tot MiB</th>
        </tr>
      </thead>
        <tbody>"
    results += history.collect do |d|
      df = Time.at(d[2].to_i).strftime('%m/%e').sub(' ', '').sub(/^0/, '')
      "<tr>
        <td>#{df}</td>
        <td>#{number_with_delimiter(d[3].to_i, delimiter: ',')}</td>
        <td>#{number_with_delimiter(d[4].to_i, delimiter: ',')}</td>
        <td>#{number_with_delimiter(d[3].to_i + d[4].to_i, delimiter: ',')}</td>
      </tr>"
    end
    results << "</tbody></table>"
    results.join("").html_safe
  end

  def days_usage oneline
    if !oneline.nil?
      content_tag :div, :class => "alert alert-info days-usage center" do
        [
          content_tag(:h2, oneline.split(';')[5]), 
          "<p><small>approximate usage today</small></p>"
        ].join("").html_safe
      end
    end
  end

  def estimated_usage vnstats
    if !vnstats.empty?
      content_tag :div, :class => "alert alert-#{vnstats[:estimated_monthly_status]} center" do
        [
          content_tag(:h2, vnstats[:estimated_monthly_usage]), 
          "<p><small>estimated end of month usage</small></p>"
        ].join("").html_safe
      end
    end
  end

  def monthly_history history
    results = []
    results << "<table id='monthly-history' class='table table-condensed table-striped table-bordered'>
      <thead>
        <tr>
          <th>Month</th>
          <th>Rec GiB</th>
          <th>Trn Gib</th>
          <th>Tot GiB</th>
        </tr>
      </thead>
        <tbody>"
    results += history.collect do |d|
      df = Time.at(d[2].to_i).strftime("%b '%y")
      "<tr>
        <td>#{df}</td>
        <td>#{number_with_precision(d[3].to_i / 1024.0, precision: 2)}</td>
        <td>#{number_with_precision(d[4].to_i / 1024.0, precision: 2)}</td>
        <td>#{number_with_precision((d[3].to_i + d[4].to_i) / 1024.0, precision: 2)}</td>
      </tr>"
    end
    results << "</tbody></table>"
    results.join("").html_safe
  end

end
