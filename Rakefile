require "jekyll/vite"
ViteRuby.install_tasks

task :all => [:resume_pdf, :build]

desc "Builds the PDF version of my resume using Typst"
task :resume_pdf do
  sh "typst", "compile", "--root=./", "--font-path=assets/fonts/", "resume/_resume2023.typ", "resume.pdf"
end

desc "Builds the Jekyll site into the default `./_site` directory"
task :build do
  sh "bundle", "exec", "jekyll", "build",  "--baseurl", ENV["JEKYLL_BASE_URL"] || ""
end
