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
30.times do |i|
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

# Industry categories
industry_categories = {
  "Technology" => [ "SaaS", "Cloud Services", "Enterprise Software", "Developer Tools" ],
  "Finance" => [ "Fintech", "Banking", "Insurance", "Investment" ],
  "Healthcare" => [ "Healthtech", "Medical Devices", "Telemedicine", "Wellness" ],
  "Education" => [ "Edtech", "E-learning", "Training", "Educational Content" ],
  "Retail" => [ "E-commerce", "Marketplace", "Consumer Goods", "Retail Tech" ],
  "Media" => [ "Social Media", "Content Creation", "Entertainment", "Gaming" ]
}

# Technology categories
technology_categories = {
  "Artificial Intelligence" => [ "Machine Learning", "Natural Language Processing", "Computer Vision", "Predictive Analytics" ],
  "Blockchain" => [ "Cryptocurrency", "Smart Contracts", "Decentralized Finance", "NFTs" ],
  "Mobile" => [ "iOS Development", "Android Development", "Cross-platform", "Mobile UX" ],
  "Web Development" => [ "Frontend", "Backend", "Full Stack", "Web Design" ],
  "Data" => [ "Big Data", "Data Analytics", "Data Visualization", "Data Engineering" ],
  "Infrastructure" => [ "Cloud Infrastructure", "DevOps", "Serverless", "Containers" ]
}

# Problem domain categories
problem_domain_categories = {
  "Customer Experience" => [ "Customer Service", "User Experience", "Customer Engagement", "Loyalty" ],
  "Marketing" => [ "Digital Marketing", "Content Marketing", "SEO", "Social Media Marketing" ],
  "Operations" => [ "Supply Chain", "Logistics", "Inventory Management", "Process Automation" ],
  "Security" => [ "Cybersecurity", "Data Privacy", "Compliance", "Identity Management" ],
  "Productivity" => [ "Collaboration", "Project Management", "Time Management", "Workflow Automation" ],
  "Sustainability" => [ "Green Tech", "Renewable Energy", "Carbon Footprint", "Circular Economy" ]
}

# Job function categories
job_function_categories = {
  "Engineering" => [ "Software Development", "QA", "DevOps", "System Architecture" ],
  "Design" => [ "UX Design", "UI Design", "Product Design", "Graphic Design" ],
  "Product" => [ "Product Management", "Product Marketing", "Product Strategy", "User Research" ],
  "Sales" => [ "Sales Development", "Account Management", "Business Development", "Sales Operations" ],
  "Marketing" => [ "Growth Marketing", "Brand Marketing", "Marketing Operations", "Content Creation" ],
  "Operations" => [ "Customer Success", "Support", "HR", "Finance" ]
}

# Create hierarchical categories
def create_hierarchical_categories(categories_hash, category_type)
  categories_hash.each do |parent_name, children|
    parent = Category.find_or_create_by!(name: parent_name) do |cat|
      cat.category_type = category_type
      cat.slug = parent_name.parameterize
    end

    # Update the category_type if it's an existing category
    unless parent.category_type == category_type
      parent.update(category_type: category_type)
    end

    children.each do |child_name|
      child = Category.find_or_initialize_by(name: child_name)
      child.category_type = category_type
      child.parent = parent
      child.slug = "#{parent_name.parameterize}-#{child_name.parameterize}"
      child.save!
    end
  end
end

create_hierarchical_categories(industry_categories, 'industry')
create_hierarchical_categories(technology_categories, 'technology')
create_hierarchical_categories(problem_domain_categories, 'problem_domain')
create_hierarchical_categories(job_function_categories, 'job_function')

# Create tags (both general and technology-related)
puts "Creating tags..."
general_tags = [
  # Company Characteristics
  "Remote-friendly",
  "Venture-backed",
  "Bootstrapped",
  "B2B",
  "B2C",
  "Open Source",
  "Mobile-first",
  "AI-powered",
  "Blockchain-based",
  "Early-stage",
  "Growth-stage",
  "Profitable",
  "International",
  "Local",
  "Subscription-based",
  "Platform",
  "API-first",
  "Data-driven",
  "Social Impact",
  "Green Tech",
  "Hardware",
  "Consumer",
  "SMB-focused",
  "Freemium",
  "White-label",
  "On-premise",
  "Cloud-native"
]

# Technology-related tags (matching some of our technologies)
tech_tags = [
  "Ruby on Rails",
  "JavaScript",
  "React",
  "Next.js",
  "Svelte",
  "Node.js",
  "Vue.js",
  "Django",
  "Laravel",
  "ASP.NET",
  "Flask",
  "WordPress",
  "Shopify",
  "Python",
  "PostgreSQL",
  "AWS",
  "Docker",
  "Kubernetes",
  "TypeScript",
  "GraphQL",
  "MongoDB",
  "Redis",
  "Angular"
]

# Create all tags
all_tags = []
(general_tags + tech_tags).uniq.each do |name|
  all_tags << Tag.find_or_create_by!(name: name)
end

# Separate the tags for easier access
general_tags = all_tags.select { |tag| general_tags.include?(tag.name) }
tech_tags = all_tags.select { |tag| tech_tags.include?(tag.name) }

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
  "AIAssist",
  "NextWave",
  "SvelteStack",
  "NodeNest",
  "DjangoMaster",
  "LaravelHub",
  "DotNetDev",
  "FlaskFusion",
  "WPExpert",
  "ShopifyPlus",
  "TechInnovate"
]

# Generate company names
company_names = []
100.times do
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

company_names = (predefined_companies + company_names).uniq.first(100)

# Create 100 companies
company_data = company_names.map.with_index do |name, index|
  # Select a primary category for this company
  primary_category = Category.where(category_type: 'industry').sample

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

# Get all technologies for assigning to companies
all_technologies = Technology.all.to_a

# Create a mapping between technology names and Technology objects
tech_name_to_object = {}
all_technologies.each do |tech|
  tech_name_to_object[tech.name] = tech
end

# Create companies with associations
company_data.each_with_index do |data, index|
  owner = company_owners[index % company_owners.size]

  # Select categories from different types
  industry_cats = random_sample(Category.where(category_type: 'industry'), 1, 2)
  tech_cats = random_sample(Category.where(category_type: 'technology'), 1, 2)
  problem_cats = random_sample(Category.where(category_type: 'problem_domain'), 0, 2)

  # Combine all categories for legacy association
  selected_categories = industry_cats + tech_cats + problem_cats

  # Select general tags
  selected_general_tags = random_sample(general_tags, 2, 5)

  # Select some technology tags (these will also be added as company_technologies)
  selected_tech_tags = random_sample(tech_tags, 2, 5)

  # Combine all tags
  selected_tags = selected_general_tags + selected_tech_tags

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

  # Add categories using the polymorphic association
  selected_categories.each do |category|
    company.add_category(category)
  end

  # Add tags using the polymorphic association
  selected_tags.each do |tag|
    company.add_tag(tag)
  end

  # Assign technologies to the company (including those from tech tags)
  tech_count = rand(3..8)
  additional_techs = all_technologies.sample(tech_count)

  # First, add technologies that match the tech tags
  selected_tech_tags.each do |tag|
    tech = tech_name_to_object[tag.name]
    if tech
      # Only create if it doesn't exist yet
      unless company.technologies.include?(tech)
        company.technologies << tech
      end
    end
  end

  # Then add additional technologies
  additional_techs.each do |tech|
    # Only create if it doesn't exist yet
    unless company.technologies.include?(tech)
      company.technologies << tech
    end
  end

  puts "  Added #{company.technologies.count} technologies to #{company.name}"
end

puts "Seed data created successfully!"
puts "Created #{User.count} users (#{User.admin.count} admins, #{User.company_owner.count} company owners, #{User.member.count} members)"
puts "Created #{Category.count} categories"
puts "Created #{Tag.count} tags (#{Tag.count - tech_tags.count} general, #{tech_tags.count} technology-related)"
puts "Created #{Technology.count} technologies"
puts "Created #{Company.count} companies (#{Company.published.count} published, #{Company.count - Company.published.count} unpublished)"
puts "Created #{CompanyTechnology.count} company technology associations"

# Create featured listings
puts "Creating featured listings..."

# Get some published companies, technologies, and solutions
published_companies = Company.published.to_a
technologies = Technology.all.to_a
solutions = Solution.all.to_a

# Create 10 featured listings with different categories
featured_listing_titles = [
  "Top SaaS Companies",
  "Leading Fintech Solutions",
  "Innovative Healthtech Startups",
  "Best Developer Tools",
  "Emerging AI Companies",
  "Sustainable Tech Solutions",
  "Next-Gen E-commerce Platforms",
  "Enterprise Software Leaders",
  "Blockchain Innovators",
  "Data Analytics Pioneers"
]

featured_listing_titles.each_with_index do |title, index|
  # Select a category based on the title
  category_name = case title
  when /SaaS/i then "SaaS"
  when /Fintech/i then "Fintech"
  when /Healthtech/i then "Healthtech"
  when /Developer Tools/i then "Developer Tools"
  when /AI/i then "Artificial Intelligence"
  when /Sustainable/i then "Green Tech"
  when /E-commerce/i then "E-commerce"
  when /Enterprise/i then "Enterprise Software"
  when /Blockchain/i then "Blockchain"
  when /Data Analytics/i then "Data Analytics"
  else "Technology"
  end

  category = Category.find_by(name: category_name) || Category.where(category_type: 'industry').sample

  # Create the featured listing
  featured_listing = FeaturedListing.create!(
    title: title,
    description: "A curated collection of #{title.downcase} that are making waves in the industry.",
    category: category,
    position: index + 1,
    active: true,
    featured_until: rand(30..90).days.from_now
  )

  # Add items to the featured listing
  case title
  when /SaaS|Fintech|Healthtech|E-commerce|Enterprise/i
    # Add companies
    companies = published_companies.select { |c| c.categories.include?(category) }.sample(5)
    companies.each do |company|
      featured_listing.add_item(company)
    end
  when /Developer Tools|AI|Blockchain|Data Analytics/i
    # Add technologies - just take random technologies since they don't have categories
    technologies.sample(5).each do |tech|
      featured_listing.add_item(tech)
    end
  else
    # Add solutions
    solutions = solutions.select { |s| s.categories.include?(category) }.sample(5)
    solutions.each do |solution|
      featured_listing.add_item(solution)
    end
  end

  puts "Created featured listing: #{title} with #{featured_listing.featured_listing_items.count} items"
end

puts "Created #{FeaturedListing.count} featured listings"

# Load solutions seed
load Rails.root.join('db/seeds/solutions.rb')
