class Source < ApplicationRecord
  belongs_to :user

  PARENT_DIR  = 'public'.freeze
  SOURCES_DIR = "#{PARENT_DIR}/sources".freeze
  TARGETS_DIR = "#{PARENT_DIR}/targets".freeze

  FileUtils.mkdir_p Rails.root.join(SOURCES_DIR)
  FileUtils.mkdir_p Rails.root.join(TARGETS_DIR)

  before_destroy :delete_files

  # The default value is false
  enum status: { unpublished: false, published: true }

  scope :only_public, -> source_id { where(status: :published, id: source_id) }

  def render
    ext.blank? ? render_plain : send("render_#{ext.sub('.', '')}")
  end

  def full_path
    Rails.root.join(SOURCES_DIR, filename).to_s
  end

  def target_file
    ext.blank? ? target_plain : send("target_#{ext.sub('.', '')}")
  end

  def clear_target
    remove_file target_file
  end

  def ext
    File.extname filename
  end

  def contents
    connection.download_file filename
    # File.read full_path
  end

  def puts str
    connection.upload_file filename, str
    # File.write full_path, str
  end

  private

  def render_plain
    contents
  end

  def render_html
    contents.html_safe
  end

  def render_md
    render_plain
    # download_file_temporarily do
    #   %x(#{Settings.sources.pandoc.md_to_html} -o #{target_file} #{full_path}) unless target_file.exist?
    # end
    # File.read(target_file.to_s).html_safe
  end

  def change_filetype_of_filename old_filetype, new_filetype
    filename.sub(/\.#{old_filetype}$/, ".#{new_filetype}")
  end

  def target_plain
    join_path SOURCES_DIR, filename
  end

  def target_html
    join_path SOURCES_DIR, filename
  end

  def target_md
    join_path TARGETS_DIR, change_filetype_of_filename('md', 'html')
  end

  def join_path dir, fname
    Rails.root.join dir, fname
  end

  def connection
    user.connection
  end

  def download_file_temporarily
    File.write full_path, contents
    yield if block_given?
    remove_file full_path
  end

  def remove_file fname
    FileUtils.rm fname, force: true
  end

  def delete_files
    begin
      connection.delete_file filename
    rescue
    end
    remove_file target_file if target_file.exist?
  end
end
