class GraphController < ApplicationController
  def daily_use
    raw_data = `vnstat --dumpdb | awk -F';' '{ if ($1 == "d" && $8 == 1) print $0; }'`.lines

    graph_cols = [['Day', 'Received', 'Transmitted']]
    graph_data = raw_data.collect do |r|
      f = r.split(';')
      df = Time.at(f[2].to_i).strftime('%m/%e').sub(' ', '').sub(/^0/, '')
      [ "#{df}", f[3].to_i / 1024.0, f[4].to_i / 1024.0 ]
    end

    render :json => {
      :type => 'AreaChart',

      :data => graph_cols + graph_data.reverse,

      :options => {
        :hAxis => { :title => 'Day', :textStyle => { :fontSize => 10 } },
        :vAxis => { :title => 'GiB'},
        :isStacked => true,
        :title => 'Daily Usage',
      }
    }
  end

  def monthly_use
    raw_data = `vnstat --dumpdb | awk -F';' '{ if ($1 == "m" && $8 == 1) print $0; }'`.lines

    graph_cols = [['Month', 'Received', 'Transmitted']]
    graph_data = raw_data.collect do |r|
      f = r.split(';')
      df = Time.at(f[2].to_i).strftime("%b '%y")
      [ "#{df}", f[3].to_i / 1024.0, f[4].to_i / 1024.0 ]
    end

    render :json => {
      :type => 'AreaChart',

      :data => graph_cols + graph_data.reverse,

      :options => {
        :hAxis => { :title => 'Month' },
        :vAxis => { :title => 'GiB'},
        :isStacked => true,
        :title => 'Monthly Usage',
      }
    }
  end
end
