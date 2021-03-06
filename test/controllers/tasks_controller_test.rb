require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }
  
  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
  
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # Act
      get edit_task_path(task.id)

      # Assert
      must_respond_with :success
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do
      # Act
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end
  
  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    it "can update an existing task" do
      # Arrange
      old_task = task
      edit_task = {
        task: {
          name: "edit name",
          description: "edit description",
          completed_at: nil
        }
      }

      # Act-Assert
      expect {
        patch task_path(old_task.id), params: edit_task
      }.wont_differ "Task.count"

      new_task = Task.find_by(name: edit_task[:task][:name])
      expect(new_task.description).must_equal edit_task[:task][:description]
      expect(new_task.completed_at).must_equal edit_task[:task][:completed_at]

      must_respond_with :redirect
      must_redirect_to task_path(old_task.id)

    end
    
    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1)

      must_respond_with :redirect
    end
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do
    it "can destroy a model" do
      current_task = task
      # Act
      expect {
        delete task_path(current_task.id)

        # Assert
      }.must_change 'Task.count', -1

      deleted_task = Task.find_by(name: "sample task")

      expect(deleted_task).must_be_nil

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "will redirect to the root page if given an invalid id" do
      delete task_path(-1)

      must_respond_with :redirect
    end
  end
  
  # Complete for Wave 4
  describe "toggle_complete" do
    it "can mark a complete task incomplete" do
      sample_task = task
      expect {
        patch task_complete_path(sample_task.id)
      }.wont_differ "Task.count"

      new_task = Task.find_by(name: sample_task.name)
      expect(new_task.description).must_equal sample_task.description
      expect(new_task.completed_at).must_be_nil

      must_respond_with :redirect
      must_redirect_to task_path(sample_task.id)
    end

    it "can mark an incomplete task complete" do
      sample_task = Task.create(name: 'test', description: 'test', completed_at: nil)
      expect {
        patch task_complete_path(sample_task.id)
      }.wont_differ "Task.count"

      new_task = Task.find_by(name: sample_task.name)
      expect(new_task.description).must_equal sample_task.description
      expect(new_task.completed_at).must_equal Time.now.to_s

      must_respond_with :redirect
      must_redirect_to task_path(sample_task.id)
    end

    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1)

      must_respond_with :redirect
    end
  end
end
