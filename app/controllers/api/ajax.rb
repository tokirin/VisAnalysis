module API
  class Ajax < Grape::API
    format :json
    helpers do
      def logger
        Grape::API.logger
      end
    end
    resource :data do
      desc "데이터셋 리스트 반환"
      get do
        DataSet.all
      end

      desc "데이터 셋 스트림 저장"
      post do
        logger.info "Data Stream is coming"
        data_set = JSON.parse(request.body.read)
        logger.info data_set
        {id: DataSet.set(data_set)}
      end

      desc "데이터 셋 삭제"
      delete ':id'do
        DataSet.find(params[:id]).destroy
      end

      desc "기본 차트용 데이터 셋 가져오기"
      get ':id' do
        DataSet.find(params[:id]).basic_chart
      end

      desc "회귀 분석용 차트 데이터 셋 가져오기"
      get ':id/regression' do
        x = Column.find(params[:x_id])
        y = Column.find(params[:y_id])

        DataSet.simple_reg_analysis(x,y)
      end

      desc "T-Test 통계 수치 가져오기"
      get ':id/t_test' do

        c1 = Column.find(params[:c1_id])
        c2 = Column.find(params[:c2_id])

        DataSet.paired_t_test(c1,c2)
      end

      desc "평행 좌표 데이터 불러오기"
      get ':id/paracoords' do
        rows = DataSet.find(params[:id]).rows
        header = DataSet.find(params[:id]).headers
        rows = rows.map do |row|
          _row = {}
          i = 0
          row.each do |item|
            _row[header[i]] = row[i]
            i = i+1
          end
          _row
        end
        rows
      end
    end
  end
end