class RevisionsController < ApplicationController
  def index
    render_json current_site.revisions.order(number: :desc), root: :revisions
  end

  def create
    revision = current_site.new_revision

    if revision.save
      render_json revision, status: :created, root: :revision
    else
      render_errors revision
    end
  end

  def commit
    site = current_revision.site
    site.update!(current_revision: current_revision)
    render_json current_revision, root: :revision
  end

  private

  def current_site
    @current_site ||= current_user.sites.find_by!(domain: params[:site_id])
  end

  def current_revision
    @current_revision ||= current_site.revisions.find_by!(number: params[:id])
  end
end
