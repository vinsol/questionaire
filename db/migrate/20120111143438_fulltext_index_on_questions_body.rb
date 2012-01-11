class FulltextIndexOnQuestionsBody < ActiveRecord::Migration
  def self.up
    execute('ALTER TABLE questions ENGINE = MyISAM')
    execute('CREATE FULLTEXT INDEX fulltext_body ON questions (body)')
  end

  def self.down
    execute('ALTER TABLE questions ENGINE = innodb')
    execute('DROP INDEX fulltext_body ON questions')
  end
end
