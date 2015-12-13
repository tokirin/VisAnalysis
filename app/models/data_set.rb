class DataSet
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :columns, dependent: :destroy

  field :data_name, type: String
  field :col_num, type: Integer

  def self.set(data)
    field_hash = Hash.new
    logger.info data

    data['meta']['fields'].map do |x|
      field_hash[x] = Array.new
    end

    data['data'].map do |x|
      logger.info x
      x.map do |k,v|
        field_hash[k] << v
      end
    end

    logger.info field_hash
    logger.info field_hash.keys

    data_set = DataSet.new
    data_set.data_name = data['meta']['data_name']
    data_set.col_num = field_hash.keys.size
    data_set.save

    field_hash.map do |k,v|
      col = Column.new(name:k, values:v)
      col.save
      data_set.columns.push(col)
    end
    data_set.id
  end


  #CALCULATE:  Correlation Coefficient(상관계수) of Simple Regression Analysis
  #PARAMS : x-column, y-column
  def self.simple_reg_cc(x,y)

    #x,y의 평균
    avg_x = x.average
    avg_y = y.average

    #row array 생성
    rg_rows = Array.new(x.values.size){Array.new(2)}
    for i in 0...x.values.size
      rg_rows[i] = [x.values[i],y.values[i]]
    end

    #x값 기준 정렬
    sorted_rows = rg_rows.sort_by{|e| e[0]}
    #각 평균값과의 차의 배열
    avg_error = sorted_rows.map{|e| [e[0]-avg_x,e[1]-avg_y]}

    #상관계수 분자계산(평균과의 차를 곱한것의 합)
    numerator = avg_error.map{|e| e[0] * e[1]}.sum

    #상관계수 분모 계산(각각의 평균과의 차를 제곱하여 합한다음 곱해서 제곱근)
    sum_x = avg_error.map{|e| e[0] ** 2}.sum
    sum_y = avg_error.map{|e| e[1] ** 2}.sum
    denominator = Math.sqrt(sum_x * sum_y)

    numerator/denominator
  end

  #CALCULATE: coefficient of determination(결정계수 계산)
  #PARAMS : x-column, y-column
  def self.simple_reg_dc(x,y)
    self.simple_reg_cc(x,y) ** 2
  end

  #CALCULATE: function of Regression(회귀식 계산)
  #PARAMS : x-column, y-column
  def self.simple_reg_analysis(x,y)

    avg_x = x.average
    avg_y = y.average

    #row array 생성
    rg_rows = Array.new(x.values.size){Array.new(2)}
    for i in 0...x.values.size
      rg_rows[i] = [x.values[i],y.values[i]]
    end

    #x값 기준 정렬
    sorted_rows = rg_rows.sort_by{|e| e[0]}
    #각 평균값과의 차의 배열
    avg_error = sorted_rows.map{|e| [e[0]-avg_x,e[1]-avg_y]}

    #기울기 분자계산(평균과의 차를 곱한것의 합)
    numerator = avg_error.map{|e| e[0] * e[1]}.sum

    #기울기 분모(x평균차의 제곱의 합)
    denominator = avg_error.map{|e| e[0] ** 2}.sum


    a = numerator/denominator
    y_intercept = avg_y - (a*avg_x)
    supposed = DataSet.regression_supposed(x.values,a,y_intercept).unshift('regression')
    sample_num = x.values.size

    result = {a:a,
     y_intercept:y_intercept,
     supposed: supposed,
     cc: DataSet.simple_reg_cc(x,y),
     dc: DataSet.simple_reg_dc(x,y),
     sample_num: sample_num,
     std_error: DataSet.std_error(y,supposed,sample_num),
     x:x.values.unshift(x.name + '_x'),
     y:y.values.unshift(y.name)
    }

    regression_data = {
        bindto: '#regression_chart',
        data:{
            xs:{
                result[:y][0] => result[:x][0],
                regression:  result[:x][0]
            },
            columns: [result[:x],result[:y],result[:supposed]],
            type: 'scatter',
            types:{
                regression: 'line'
            }
        },
        axis:{
            x:{
                label: result[:x][0]
            },
            y:{
                label: result[:y][0]
            }
        },
        zoom:{
            enabled: true
        }
    }

    {chart_data: regression_data, result_data:result}
  end


  def self.regression_supposed(x,a,y)
    x.map{|x| a * x + y}
  end

  def self.std_error(y,supposed,sample_number)
    sse = 0.0
    for i in 0...y.values.size
      sse = sse + ((y.values[i] - supposed[i+1]) ** 2)
    end
    Math.sqrt(sse/(sample_number-2.0))
  end

  def self.paired_t_test(x,y)
    size = x.values.size
    freedom = size-1
    avg_x = x.average
    avg_y = y.average

    #row array 생성
    rg_rows = Array.new(x.values.size){Array.new(2)}
    for i in 0...x.values.size
      rg_rows[i] = [x.values[i],y.values[i]]
    end

    #x값 기준 정렬
    sorted_rows = rg_rows.sort_by{|e| e[0]}
    #각 평균값과의 차의 배열
    avg_error = sorted_rows.map{|e| [e[0]-avg_x,e[1]-avg_y]}

    t_value = Math.sqrt(size * (size - 1)/ avg_error.map { |x|  (x[0] - x[1]) ** 2 }.sum) * (avg_x - avg_y)


    result = {
     correlation: DataSet.simple_reg_cc(x,y).round(6),
     hypo_diff: 0,
     freedom: freedom,
     t_value:t_value.round(6)
    }

    # return Data
    {
        basic_data:{
            columns:[x.name,y.name],
            avgs:[x.average.round(6),y.average.round(6)],
            vars:[x.variance.round(6),y.variance.round(6)],
            size: size
        },
        result_data: result
    }

  end

  def correlation_analysis
    result = Hash.new
    arr1 = self.cols
    arr2 = self.cols
    arr1.each do |c1|
      result[c1.name] = Hash.new
      arr2.each do |c2|
        result[c1.name][c2.name] = DataSet.simple_reg_cc(c2,c1)
      end
    end
    result
  end


  #데이터의 각종 메타정보들 계산
  def headers
    self.columns.map{|x| x.name}
  end

  def cols
    self.columns
  end

  def rows
    rows = Array.new(self.max_column_size){Array.new}
    self.columns.each do |x|
      for i in 0...x.values.length
        rows[i] << x.values[i]
      end
    end
    rows
  end

  def values
    self.columns.map {|x| x.values}
  end

  def max_column_size
    self.columns.map{|x| x.values.size}.max
  end

  def basic_chart
    {columns: self.columns.map{|x| x.values[0...100].unshift x.name}}
  end


end
