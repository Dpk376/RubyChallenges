class User
    attr_reader :username, :password, :role
  
    def initialize(username, password, role)
      @username = username
      @password = password
      @role = role
    end
  
    def login(input_username, input_password)
      @username == input_username && @password == input_password
    end
  end
  
  class Article
    attr_reader :title, :content, :category
  
    def initialize(title, content, category)
      @title = title
      @content = content
      @category = category
    end
  
    def content=(new_content)
      @content = new_content
    end
  end
  
  class CMS
    def initialize
      @users = []
      @articles = []
      @audit_trail = []
    end
  
    def add_user(username, password, role)
      user = User.new(username, password, role)
      @users << user
      user
    end
  
    def authenticate(username, password)
      user = @users.find { |u| u.login(username, password) }
      raise "Authentication failed" unless user
  
      user
    end
  
    def add_article(user, title, content, category)
      raise "Unauthorized: Insufficient privileges" unless user.role == 'Admin' || user.role == 'Editor'
  
      article = Article.new(title, content, category)
      @articles << article
      add_audit_entry(user, "Added article '#{title}'")
      article
    end
  
    def list_articles
      @articles.map { |article| "#{article.title} (#{article.category})" }
    end
    
    def delete_article(user, title)
        raise "Unauthorized: Insufficient privileges" unless user.role == 'Admin'
      
        article_index = @articles.find_index { |a| a.title == title }
        raise "Article '#{title}' not found" unless article_index
      
        deleted_article = @articles.delete_at(article_index)
        add_audit_entry(user, "Deleted article '#{title}'")
        deleted_article
      end
      
  
  
  
    def update_article(user, title, new_content)
      raise "Unauthorized: Insufficient privileges" unless user.role == 'Admin' || user.role == 'Editor'
  
      article = find_article(title)
      article.content = new_content
      add_audit_entry(user, "Updated content of '#{title}'")
      article
    end
  
    def add_audit_entry(user, action)
      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      @audit_trail << "#{timestamp} - #{user.username} (#{user.role}): #{action}"
    end
  
    def show_audit_trail
      @audit_trail
    end
  
    private
  
    def find_article(title)
      article = @articles.find { |a| a.title == title }
      raise "Article '#{title}' not found" unless article
  
      article
    end
  end
  
