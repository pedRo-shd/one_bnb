require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "PUT #update" do
    before do
      # Método do FactoryGirl
      @user = create(:user)
      @auth_headers = @user.create_new_auth_token # Autorizando usuarios com helper do devise create_new_auth_token devise
      # Aqui estamos setando a chamada como json (isso pega a URL users.json ao invés de users)
      request.env["HTTP_ACCEPT"] = 'application/json'
      # Aqui estamos preparando os atributos que serão atualizados no User
      @new_attributes = {name: FFaker::Name.name}
    end

      context "with valid params and tokens" do
        before do
          # Aqui nós estamos colocando no header os tokens (Sem isso a chamada seria bloqueada)
          request.headers.merge!(@auth_headers)
        end

        it "updates the requested user" do
          put :update, params: {id: @user.id, user: @new_attributes}
          @user.reload # Reload pega o @user atualizado
          # Espera que o @user.name seja igual a @new_attributes name
          expect(@user.name).to eql(@new_attributes[:name])
        end

        it "updates the requested user with photo" do
          @attributes_with_photo = @new_attributes.merge!(photo: ('data:image/png;base64,' + Base64.encode64(file_fixture('file.png').read)))
          put :update, params: {id: @user.id, user: @attributes_with_photo}
          @user.reload # reload chama um novo user atualizado que neste block estamos testando a atualizaçaõr do @user
          expect(@user.photo.present?).to eql(true)
        end
      end

    context "with invalid token" do
      it "not updates the requested user" do
        @name = FFaker::Name.name
        put :update, params: {id: @user.id, user: @new_attributes}
        expect(response.status).to eql(401)
      end
    end
  end

end
