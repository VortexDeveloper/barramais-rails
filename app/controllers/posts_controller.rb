class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :comments, :comment]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.create_post(post_params)

    respond_to do |format|
      if @post.persisted?
        save_post_images(@post) if media_params.present?
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    respond_to do |format|
      if @post.liked_by current_user
        # format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        # format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def comment
    @comment = Comment.build_from(@post, current_user.id, comment_params[:body])

    respond_to do |format|
      if @comment.save
        # format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :comment, status: :ok }
      else
        # format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def comments
    @comments = @post.root_comments.order(created_at: :asc)
  end

  private
    def save_post_images(post)
      media_params[:medias].each do |mparam|
        image = Paperclip.io_adapters.for(mparam[:image])
        image.original_filename = "#{current_user.id}#{mparam[:filename]}"
        post_image = PostImage.new
        post_image.image = image
        post.post_images << post_image
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(
        :description,
        :user_id
      )
    end

    def comment_params
      params.require(:comment).permit(
        :body
      )
    end

    def media_params
      params.permit(medias: [:image, :filename])
    end
end
