require 'minitest/autorun'
require_relative './cmstest'  # Replace 'your_file_name' with the actual filename

class TestCMS < Minitest::Test
  def setup
    @cms = CMS.new
    @admin_user = @cms.add_user("admin", "admin_password", "Admin")
    @editor_user = @cms.add_user("editor", "editor_password", "Editor")
    @viewer_user = @cms.add_user("viewer", "viewer_password", "Viewer")
  end

  def test_user_authentication
    authenticated_user = @cms.authenticate("admin", "admin_password")
    assert_equal @admin_user, authenticated_user
  end

  def test_invalid_user_authentication
    assert_raises(RuntimeError) do
      @cms.authenticate("nonexistent_user", "invalid_password")
    end
  end

  def test_add_and_list_articles
    admin_user_authenticated = @cms.authenticate("admin", "admin_password")

    article = @cms.add_article(admin_user_authenticated, "Introduction to Ruby", "Ruby is a dynamic programming language.", "Programming")

    assert_equal 1, @cms.list_articles.length
    assert_equal "Introduction to Ruby (Programming)", @cms.list_articles.first
  end

  def test_delete_article_by_admin
    admin_user_authenticated = @cms.authenticate("admin", "admin_password")

    @cms.add_article(admin_user_authenticated, "Introduction to Ruby", "Ruby is a dynamic programming language.", "Programming")

    assert_equal 1, @cms.list_articles.length

    deleted_article = @cms.delete_article(admin_user_authenticated, "Introduction to Ruby")

    assert_equal 0, @cms.list_articles.length
    assert_instance_of Article, deleted_article
    assert_equal "Introduction to Ruby", deleted_article.title
  end

  def test_unauthorized_delete_article_by_editor
    editor_user_authenticated = @cms.authenticate("editor", "editor_password")

    @cms.add_article(editor_user_authenticated, "Introduction to Ruby", "Ruby is a dynamic programming language.", "Programming")

    assert_raises(RuntimeError) do
      @cms.delete_article(editor_user_authenticated, "Introduction to Ruby")
    end
  end

  def test_unauthorized_update_article_by_viewer
    viewer_user_authenticated = @cms.authenticate("viewer", "viewer_password")
  
    assert_raises(RuntimeError, "Unauthorized: Insufficient privileges") do
      @cms.add_article(viewer_user_authenticated, "Introduction to Ruby", "Ruby is a dynamic programming language.", "Programming")
      @cms.update_article(viewer_user_authenticated, "Introduction to Ruby", "Updated content.")
    end
  end
  

  def test_audit_trail_after_adding_and_deleting_article
    admin_user_authenticated = @cms.authenticate("admin", "admin_password")

    @cms.add_article(admin_user_authenticated, "Introduction to Ruby", "Ruby is a dynamic programming language.", "Programming")
    @cms.delete_article(admin_user_authenticated, "Introduction to Ruby")

    audit_trail = @cms.show_audit_trail

    assert_equal 2, audit_trail.length
    assert_match(/Added article 'Introduction to Ruby'/, audit_trail.first)
    assert_match(/Deleted article 'Introduction to Ruby'/, audit_trail.last)
  end
end
