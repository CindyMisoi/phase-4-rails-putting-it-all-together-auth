class RecipesController < ApplicationController

    # get all recipes after logging in
    before_action :authorize
    def index
        if session[:user_id]
            recipes = Recipe.all
            render json: recipes, include: [user: { only: [:id, :username, :image_url, :bio] }], status: :created
        else
            render json: { errors: ["You need to log in to view recipes"] }, status: :unauthorized 
        end
    end

    # create recipes
    def create
        user = User.find_by(id: session[:user_id])
        recipe = Recipe.create(recipe_params.merge(user_id: user.id));
        

        if recipe.valid?
            render json: recipe, include: :user, status: :created
        else
            render json: {errors: recipe.errors.full_messages} , status: :unprocessable_entity
        end
    end
    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
    def authorize
        render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
    end
end
