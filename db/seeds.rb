# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Set locale for Faker
Faker::Config.locale = 'en'

# Load technology seeds
load Rails.root.join('db/seeds/technologies.rb')

# Clear existing data
puts "Cleaning database..."
Company.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: :admin
)

# Create company owners
puts "Creating company owners..."
company_owners = []
15.times do |i|
  company_owners << User.create!(
    email: "owner#{i+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    role: :company_owner
  )
end

# Create regular members
puts "Creating regular members..."
20.times do |i|
  User.create!(
    email: "member#{i+1}@example.com",
    password: 'password',
    password_confirmation: 'password',
    role: :member
  )
end

# Create categories
puts "Creating categories..."
categories = [
  "SaaS",
  "Fintech",
  "Healthtech",
  "E-commerce",
  "Edtech",
  "AI/ML",
  "Mobile Apps",
  "Developer Tools",
  "Blockchain",
  "IoT",
  "Cybersecurity",
  "Cloud Services",
  "Data Analytics",
  "AR/VR",
  "Gaming",
  "Social Media",
  "Marketplace",
  "Productivity",
  "Enterprise Software",
  "Sustainability"
].map do |name|
  Category.create!(name: name)
end

# Create tags
puts "Creating tags..."
tags = [
  # Programming Languages
  "Ruby on Rails",
  "JavaScript",
  "Python",
  "Go",
  "Rust",
  "Java",
  "C#",
  "PHP",
  "TypeScript",
  "Swift",

  # Frontend Frameworks
  "React",
  "Vue.js",
  "Angular",
  "Svelte",
  "Next.js",

  # Backend & Databases
  "Node.js",
  "Django",
  "Laravel",
  "PostgreSQL",
  "MongoDB",
  "MySQL",
  "Redis",
  "GraphQL",

  # Cloud & DevOps
  "AWS",
  "Google Cloud",
  "Azure",
  "Docker",
  "Kubernetes",
  "CI/CD",
  "Terraform",

  # Company Characteristics
  "Remote-friendly",
  "Venture-backed",
  "Bootstrapped",
  "B2B",
  "B2C",
  "Open Source",
  "Enterprise",
  "Mobile-first",
  "AI-powered",
  "Blockchain-based"
].map do |name|
  Tag.create!(name: name)
end

# Create companies
puts "Creating companies..."

# Helper method to get random elements from an array
def random_sample(array, min_count = 1, max_count = nil)
  max_count ||= array.size
  count = rand(min_count..max_count)
  array.sample(count)
end

# Helper method to generate a realistic company description
def generate_company_description(company_name, category)
  industry_terms = {
    "SaaS" => [ "cloud-based", "subscription", "scalable", "enterprise", "solution" ],
    "Fintech" => [ "financial", "banking", "payment", "investment", "blockchain" ],
    "Healthtech" => [ "healthcare", "medical", "patient", "clinical", "wellness" ],
    "E-commerce" => [ "retail", "shopping", "marketplace", "consumer", "products" ],
    "Edtech" => [ "education", "learning", "students", "courses", "training" ],
    "AI/ML" => [ "artificial intelligence", "machine learning", "predictive", "algorithms", "neural networks" ],
    "Mobile Apps" => [ "mobile", "app", "smartphone", "iOS", "Android" ],
    "Developer Tools" => [ "developer", "programming", "code", "workflow", "productivity" ],
    "Blockchain" => [ "decentralized", "crypto", "smart contracts", "tokens", "ledger" ],
    "IoT" => [ "connected devices", "sensors", "smart home", "industrial", "monitoring" ],
    "Cybersecurity" => [ "security", "protection", "threat detection", "encryption", "compliance" ],
    "Cloud Services" => [ "cloud", "infrastructure", "hosting", "serverless", "storage" ],
    "Data Analytics" => [ "analytics", "big data", "insights", "visualization", "reporting" ],
    "AR/VR" => [ "augmented reality", "virtual reality", "immersive", "3D", "simulation" ],
    "Gaming" => [ "games", "entertainment", "interactive", "multiplayer", "esports" ],
    "Social Media" => [ "social", "community", "content", "engagement", "networking" ],
    "Marketplace" => [ "platform", "buyers", "sellers", "transactions", "listings" ],
    "Productivity" => [ "workflow", "efficiency", "collaboration", "automation", "organization" ],
    "Enterprise Software" => [ "enterprise", "business", "corporate", "management", "solution" ],
    "Sustainability" => [ "sustainable", "green", "eco-friendly", "environmental", "renewable" ]
  }

  terms = industry_terms[category] || industry_terms.values.flatten.sample(5)

  intro_phrases = [
    "#{company_name} is revolutionizing the #{category.downcase} industry with",
    "#{company_name} provides cutting-edge solutions for",
    "#{company_name} is a leading provider of",
    "#{company_name} helps businesses transform through",
    "#{company_name} delivers innovative #{category.downcase} solutions with",
    "#{company_name} is building the future of #{category.downcase} through",
    "#{company_name} empowers organizations with",
    "#{company_name} specializes in developing",
    "#{company_name} offers a comprehensive platform for",
    "#{company_name} is disrupting the #{category.downcase} space with"
  ]

  middle_phrases = [
    "its state-of-the-art platform that combines",
    "a suite of powerful tools featuring",
    "an innovative approach that integrates",
    "a user-friendly solution that leverages",
    "advanced technology that harnesses",
    "a scalable infrastructure built on",
    "intelligent systems that utilize",
    "a comprehensive ecosystem that incorporates",
    "a next-generation platform powered by",
    "a robust framework that implements"
  ]

  benefit_phrases = [
    "enabling businesses to streamline operations and drive growth.",
    "helping organizations make data-driven decisions with confidence.",
    "allowing companies to scale efficiently while reducing costs.",
    "empowering teams to collaborate effectively and boost productivity.",
    "providing actionable insights that lead to measurable results.",
    "transforming complex processes into simple, intuitive workflows.",
    "creating exceptional experiences for both businesses and their customers.",
    "addressing critical challenges faced by modern enterprises.",
    "delivering measurable ROI through innovative technology solutions.",
    "setting new standards for performance, security, and reliability."
  ]

  "#{intro_phrases.sample} #{middle_phrases.sample} #{terms.sample(3).join(', ')}, and #{terms.sample(2).join(' and ')}, #{benefit_phrases.sample}"
end

# Generate company names
company_names = []
50.times do
  name = ""
  loop do
    name_type = rand(4)
    case name_type
    when 0
      # Two words
      name = "#{Faker::Company.buzzword.capitalize} #{Faker::Company.industry.split.first.capitalize}"
    when 1
      # Made-up word
      name = Faker::Company.name.split.first
    when 2
      # Tech-sounding name
      prefix = [ "Tech", "Cloud", "Data", "Code", "Dev", "Net", "Byte", "App", "Web", "Digi" ].sample
      suffix = [ "ify", "ly", "io", "ics", "ware", "able", "hub", "base", "sync", "flow" ].sample
      name = "#{prefix}#{suffix}"
    when 3
      # Two-word combination with adjective and noun
      name = "#{Faker::Adjective.positive.capitalize}#{Faker::Company.buzzword.capitalize}"
    end

    # Ensure uniqueness
    break unless company_names.include?(name)
  end
  company_names << name
end

# Add some predefined companies to ensure quality
predefined_companies = [
  "RailsForge",
  "HealthTrack",
  "FinFlow",
  "EduSpark",
  "DevOpsHub",
  "ShopSmart",
  "DataViz",
  "BlockChain Solutions",
  "IoT Connect",
  "AIAssist"
]

company_names = (predefined_companies + company_names).uniq.first(50)

# Create 50 companies
company_data = company_names.map.with_index do |name, index|
  # Select a primary category for this company
  primary_category = categories.sample

  # Generate a realistic website URL
  domain_suffix = [ ".com", ".io", ".co", ".tech", ".app" ].sample
  website_name = name.downcase.gsub(/[^a-z0-9]/, '')
  website = "https://#{website_name}#{domain_suffix}"

  # Generate a location
  location = "#{Faker::Address.city}, #{Faker::Address.state_abbr}"

  # Determine if the company is published (70% chance)
  published = rand < 0.7

  # Generate a detailed description
  description = generate_company_description(name, primary_category.name)

  {
    name: name,
    description: description,
    website: website,
    location: location,
    published: published
  }
end

# Create companies with associations
company_data.each_with_index do |data, index|
  owner = company_owners[index % company_owners.size]

  # Select categories and tags
  selected_categories = random_sample(categories, 1, 3)
  selected_tags = random_sample(tags, 3, 8)

  company = Company.new(
    data.merge(
      owner: owner,
      created_by: admin, # Set created_by to admin to bypass validation
      categories: selected_categories,
      tags: selected_tags
    )
  )

  # Skip logo attachment for now as we don't have the default image
  # We'll let the app use its default placeholder handling

  company.save!
  puts "Created company: #{company.name}"
end

puts "Seed data created successfully!"
puts "Created #{User.count} users (#{User.admin.count} admins, #{User.company_owner.count} company owners, #{User.member.count} members)"
puts "Created #{Category.count} categories"
puts "Created #{Tag.count} tags"
puts "Created #{Company.count} companies (#{Company.published.count} published, #{Company.count - Company.published.count} unpublished)"
