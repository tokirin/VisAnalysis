class Column
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :data_set
  before_save :init

  field :name, type: String
  field :values, type: Array

  field :average, type: Float
  field :variance, type: Float
  field :std_dv, type: Float
  field :x_axis_flag, type: Boolean, default:false


  private
  def init
    set_average
    set_variance
    set_std_dv
    set_x_axis_flag
  end

  def set_average
    begin
      self.average = self.values.reduce(:+) / self.values.size.to_f
    rescue
      puts self.values
    end
  end

  def set_variance
    powered_error = self.values.map{|x| (x - self.average) ** 2}
    self.variance = powered_error.reduce(:+) / powered_error.size.to_f
  end

  def set_std_dv
    self.std_dv = Math.sqrt(self.variance)
  end

  def set_x_axis_flag
    if self.values.group_by { |v| v }.select { |k, v| v.count > 1 }.keys.empty?
      self.x_axis_flag = true
    else
      self.x_axis_flag = false
      return 'result is not false fuckin asshole'
    end
  end

end
