class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Rails.cache.fetch('posts.all') do
      Post.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Rails.cache.fetch("post-#{params[:id]}") do
      Post.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Rails.cache.fetch("post-#{params[:id]}") do
      Post.find(params[:id])
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
    	Rails.cache.delete('posts.all')
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Rails.cache.fetch("post-#{params[:id]}") do
      Post.find(params[:id])
    end

    respond_to do |format|
      if @post.update_attributes(params[:post])
        Rails.cache.delete('posts.all')
        Rails.cache.write("post-#{params[:id]}", @post)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    Rails.cache.delete('posts.all')
    Rails.cache.delete("post-#{params[:id]}")

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
