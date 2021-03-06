class ThinkingsController < ApplicationController

  def new
    @thinking = Thinking.new
  end
  
  def create
    @thinking = Thinking.new(thinking_params)
    @thinking.user_id = current_user.id
    if @thinking.save
      flash[:success] = "新たな思考を追加しました!"
      redirect_to thinkings_path
    else
      redirect_to new_thinking_path
    end
  end
  
  def edit
    @thinking = Thinking.find(params[:id])
  end
  
  def update
    @thinking = Thinking.find(params[:id])
    if @thinking.update_attributes(thinking_params)
      flash[:success] = "思考を更新しました!"
      redirect_to thinkings_path
    else
      render 'edit'
    end
  end

  def index
    @thinkings = Thinking.paginate(page: params[:page], per_page: 2)
    @routine_actions = current_user.routine_actions
  end

  def show
    @thinking = Thinking.find(params[:id])
    @relationship = current_user.relationships.find_by(thinking_id: @thinking.id)
  end
  
  def destroy
    Thinking.find(params[:id]).destroy
    flash[:danger] = "思考を削除しました!"
    redirect_to thinkings_path
  end  

  def routine
    @routine_actions = current_user.routine_actions
  end
  
  def download
    respond_to do |format|
        format.html
        format.pdf do
            render :pdf      => 'routine_check_sheet', # 出力される際のファイル名
                   :template => 'download.pdf.erb', # どのViewファイルを使用するか
                   :layout   => 'pdf.html.erb', # どのレイアウトファイルを使用するか
                   :encoding => 'UTF-8' # 日本語を使う場合は指定してください
        end
    end  
  end
  
  private
  def thinking_params
    params.require(:thinking).permit(:factor, :action_plan1, :action_plan2,
                                 :action_plan3,:action_plan4,:action_plan5,
                                 :action_plan6, :action_plan7,
                                 :action_plan8,:action_plan9,:action_plan10)
  end
  
end
