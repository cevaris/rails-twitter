require 'test_helper'

class EventApplicationsControllerTest < ActionController::TestCase
  setup do
    @event_application = event_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_application" do
    assert_difference('EventApplication.count') do
      post :create, event_application: { name: @event_application.name }
    end

    assert_redirected_to event_application_path(assigns(:event_application))
  end

  test "should show event_application" do
    get :show, id: @event_application
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_application
    assert_response :success
  end

  test "should update event_application" do
    patch :update, id: @event_application, event_application: { name: @event_application.name }
    assert_redirected_to event_application_path(assigns(:event_application))
  end

  test "should destroy event_application" do
    assert_difference('EventApplication.count', -1) do
      delete :destroy, id: @event_application
    end

    assert_redirected_to event_applications_path
  end
end
