# Create technology categories and technologies
puts "Creating technologies..."

# Programming Languages
languages = [
  { name: "Ruby", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ruby/ruby-original.svg" },
  { name: "JavaScript", popularity: 95, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg" },
  { name: "TypeScript", popularity: 90, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/typescript/typescript-original.svg" },
  { name: "Python", popularity: 85, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" },
  { name: "PHP", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg" },
  { name: "Java", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg" },
  { name: "C#", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/csharp/csharp-original.svg" },
  { name: "Go", popularity: 65, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/go/go-original-wordmark.svg" },
  { name: "Swift", popularity: 60, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/swift/swift-original.svg" },
  { name: "Kotlin", popularity: 55, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kotlin/kotlin-original.svg" }
]

languages.each do |lang|
  Technology.find_or_create_by(name: lang[:name]) do |tech|
    tech.category = "Programming Language"
    tech.popularity = lang[:popularity]
    tech.logo_url = lang[:logo_url]
  end
end

# Frameworks
frameworks = [
  { name: "Ruby on Rails", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rails/rails-original-wordmark.svg" },
  { name: "React", popularity: 90, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg" },
  { name: "Angular", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/angularjs/angularjs-original.svg" },
  { name: "Vue.js", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vuejs/vuejs-original.svg" },
  { name: "Django", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/django/django-plain.svg" },
  { name: "Laravel", popularity: 65, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/laravel/laravel-plain.svg" },
  { name: "Express.js", popularity: 85, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/express/express-original.svg" },
  { name: "Spring Boot", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/spring/spring-original.svg" },
  { name: "ASP.NET Core", popularity: 65, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg" },
  { name: "Flutter", popularity: 60, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" }
]

frameworks.each do |framework|
  Technology.find_or_create_by(name: framework[:name]) do |tech|
    tech.category = "Framework"
    tech.popularity = framework[:popularity]
    tech.logo_url = framework[:logo_url]
  end
end

# Databases
databases = [
  { name: "PostgreSQL", popularity: 85, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" },
  { name: "MySQL", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg" },
  { name: "MongoDB", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mongodb/mongodb-original.svg" },
  { name: "Redis", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" },
  { name: "SQLite", popularity: 65, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sqlite/sqlite-original.svg" },
  { name: "Microsoft SQL Server", popularity: 60, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/microsoftsqlserver/microsoftsqlserver-plain.svg" },
  { name: "Elasticsearch", popularity: 55, logo_url: "https://www.vectorlogo.zone/logos/elastic/elastic-icon.svg" },
  { name: "Firebase", popularity: 65, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg" }
]

databases.each do |db|
  Technology.find_or_create_by(name: db[:name]) do |tech|
    tech.category = "Database"
    tech.popularity = db[:popularity]
    tech.logo_url = db[:logo_url]
  end
end

# Frontend
frontend = [
  { name: "HTML", popularity: 95, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg" },
  { name: "CSS", popularity: 95, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg" },
  { name: "Tailwind CSS", popularity: 85, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tailwindcss/tailwindcss-plain.svg" },
  { name: "Bootstrap", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/bootstrap/bootstrap-original.svg" },
  { name: "Sass", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sass/sass-original.svg" },
  { name: "jQuery", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jquery/jquery-original.svg" },
  { name: "Next.js", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nextjs/nextjs-original.svg" },
  { name: "Svelte", popularity: 60, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/svelte/svelte-original.svg" },
  { name: "Hotwire", popularity: 65, logo_url: "https://hotwired.dev/assets/images/social/hotwire-social-card-1280x640-fc1e760d.png" }
]

frontend.each do |fe|
  Technology.find_or_create_by(name: fe[:name]) do |tech|
    tech.category = "Frontend"
    tech.popularity = fe[:popularity]
    tech.logo_url = fe[:logo_url]
  end
end

# DevOps
devops = [
  { name: "Docker", popularity: 85, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" },
  { name: "Kubernetes", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kubernetes/kubernetes-plain.svg" },
  { name: "AWS", popularity: 90, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-original.svg" },
  { name: "Google Cloud", popularity: 80, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/googlecloud/googlecloud-original.svg" },
  { name: "Azure", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg" },
  { name: "Jenkins", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/jenkins/jenkins-original.svg" },
  { name: "GitHub Actions", popularity: 75, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" },
  { name: "Terraform", popularity: 70, logo_url: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" }
]

devops.each do |ops|
  Technology.find_or_create_by(name: ops[:name]) do |tech|
    tech.category = "DevOps"
    tech.popularity = ops[:popularity]
    tech.logo_url = ops[:logo_url]
  end
end

puts "Technologies created!"
