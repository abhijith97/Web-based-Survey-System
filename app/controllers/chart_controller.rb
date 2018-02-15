class ChartController < ApplicationController
	def index
		sql="select survey_sets.name,  count(*) from ques, resps, survey_sets where ques.id =  resps.Que_id and ques.SurveySet_id = survey_sets.id group by ques.SurveySet_id"
		@records_array = ActiveRecord::Base.connection.execute(sql)

	end
end