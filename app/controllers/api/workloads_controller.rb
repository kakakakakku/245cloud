class Api::WorkloadsController < ApplicationController
  def index
    type = params[:type]
    limit = params[:limit] || 48
    scope = Workload.of_type(type)
    id = params[:facebook_id]
    scope = scope.his(id).dones if id 
    scope = scope.limit(limit) if scope.limit_value.nil?
    if params[:best]
      scope = scope.bests
    elsif params[:weekly_ranking]
      scope = scope.weekly_ranking
    else
      scope = scope.created
    end
    scope = scope.decorate.reverse
    render json: scope
  end

  def complete # TODO: PUT update にする
    render json: Workload.his(
      current_user.facebook_id
    ).created.first.to_done!.decorate
  end

  def create
    workload = Workload.create!(
      facebook_id: current_user.facebook_id,
      music_key: params['music_key'].presence,
      title: params['title'].presence,
      artwork_url: params['artwork_url'].presence
    )
    if params['issue_id']
      issue = Issue.find(params['issue_id'])
      raise unless issue.user.id == current_user.id
      IssueWorkload.create!(
        issue: issue,
        workload: workload
      )
      issue.worked = issue.workloads.select{|w| w.is_done}.count
      issue.save!
    end
    render json: workload.decorate
  end
end

