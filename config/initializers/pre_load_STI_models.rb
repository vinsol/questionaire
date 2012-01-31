if Rails.env.development?
  %w[question multiple_choice subjective multiple_choice_answer].each do |c|
    require_dependency File.join("app","models","#{c}.rb")
  end
end
