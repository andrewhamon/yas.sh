class FilesController < ApplicationController
  def create
    file = current_site.account.upstream_files.find_or_initialize_by(md5: file_params[:md5])
    file.size = file_params[:size]
    file.content_type = file_params[:content_type]

    new_file = file.new_record?
    file.save

    unless file.save
      return render_errors file
    end

    revision_file = current_revision.revision_files.new(upstream_file: file, site_path: file_params[:path])

    unless revision_file.save
      return render_errors revision_file
    end

    result = {
      path: file_params[:path],
      size: file_params[:size],
      md5: file_params[:md5],
      content_type: file_params[:content_type],
      new_file: new_file
    }

    if new_file
      result[:upload_url] = file.presigned_url
    end

    render_json result, root: :file
  end


  def file_params
    params.permit(:domain, :revision, :path, :size, :md5, :content_type)
  end

  def current_site
    @current_site ||= current_user.sites.find_by!(domain: params[:site_id])
  end

  def current_revision
    @current_revision ||= current_site.revisions.find_by!(number: params[:revision_id])
  end
end
