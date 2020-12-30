require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  describe "GET #index" do
    context "when have least one" do
      let!(:category) {FactoryBot.create :category}
      let!(:category_two) {FactoryBot.create :category}
      before {get :index}

      it "assign a @categories and render template index" do
        aggregate_failures do
          expect(response).to render_template :index
          expect(assigns(:categories)).to eq [category, category_two]
        end
      end
    end

    context "when not have any category" do
      before {get :index}

      it "redirect to root_path with danger flash" do
        aggregate_failures do
          expect(response).to redirect_to root_path
          expect(flash[:danger]).to eq I18n.t("something_wrong")
        end
      end
    end
  end
end
