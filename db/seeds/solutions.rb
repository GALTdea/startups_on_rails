puts "Creating solutions for companies..."

# Helper method to generate a solution description
def generate_solution_description(solution_name, solution_type)
  type_terms = {
    "SaaS" => [ "cloud-based", "subscription", "scalable", "enterprise", "solution" ],
    "On-Premise" => [ "on-site", "installed", "dedicated", "enterprise", "solution" ],
    "Mobile App" => [ "mobile", "app", "smartphone", "iOS", "Android" ],
    "Desktop Application" => [ "desktop", "application", "software", "installed", "program" ],
    "Framework" => [ "framework", "development", "toolkit", "library", "platform" ],
    "Library" => [ "library", "component", "module", "package", "toolkit" ],
    "API Service" => [ "API", "service", "integration", "endpoint", "interface" ],
    "Hardware" => [ "hardware", "device", "equipment", "physical", "appliance" ],
    "Hybrid" => [ "hybrid", "combined", "integrated", "multi-platform", "versatile" ]
  }

  terms = type_terms[solution_type] || type_terms.values.flatten.sample(5)

  intro_phrases = [
    "#{solution_name} is a powerful #{solution_type.downcase} that",
    "#{solution_name} provides a comprehensive #{solution_type.downcase} solution that",
    "#{solution_name} is an innovative #{solution_type.downcase} designed to",
    "#{solution_name} offers a cutting-edge #{solution_type.downcase} that",
    "#{solution_name} delivers a robust #{solution_type.downcase} platform that"
  ]

  middle_phrases = [
    "helps businesses streamline their operations through",
    "enables organizations to optimize their workflows with",
    "allows companies to enhance their productivity using",
    "empowers teams to collaborate effectively with",
    "transforms how businesses manage their processes through"
  ]

  benefit_phrases = [
    "resulting in improved efficiency and reduced costs.",
    "leading to better decision-making and increased ROI.",
    "enabling faster time-to-market and competitive advantage.",
    "providing actionable insights and measurable results.",
    "ensuring seamless integration and scalability."
  ]

  "#{intro_phrases.sample} #{middle_phrases.sample} #{terms.sample(3).join(', ')}, #{benefit_phrases.sample}"
end

# Clear existing solutions
Solution.destroy_all
puts "Cleared existing solutions"

# Create 2-4 solutions for each published company
Company.published.each do |company|
  solution_count = rand(2..4)

  solution_count.times do
    # Randomly select a solution type
    solution_type = Solution::SOLUTION_TYPES.sample

    # Generate a solution name based on company name and solution type
    # Ensure uniqueness by adding a random suffix if needed
    base_name = [
      "#{company.name} #{solution_type}",
      "#{company.name} #{[ 'Pro', 'Enterprise', 'Suite', 'Platform', 'Cloud', 'Connect', 'Core' ].sample}",
      "#{[ 'Smart', 'Intelligent', 'Advanced', 'Pro', 'Enterprise', 'Ultimate' ].sample} #{company.name}"
    ].sample

    solution_name = base_name
    suffix_counter = 1

    # Check if the name already exists and add a suffix if needed
    while Solution.exists?(name: solution_name)
      solution_name = "#{base_name} #{suffix_counter}"
      suffix_counter += 1
    end

    # Create the solution
    solution = Solution.create!(
      name: solution_name,
      description: generate_solution_description(solution_name, solution_type),
      website: "https://#{company.name.parameterize}.example.com/#{[ 'products', 'solutions', 'services' ].sample}/#{solution_name.parameterize}",
      pricing: [ "Free", "Freemium", "Paid", "Contact for pricing", "Subscription" ].sample,
      solution_type: solution_type,
      deployment_type: Solution::DEPLOYMENT_TYPES.sample,
      popularity: rand(1..100),
      published: [ true, true, true, false ].sample, # 75% chance of being published
      company: company
    )

    puts "Created solution: #{solution.name} for #{company.name}"
  end
end

puts "Created #{Solution.count} solutions (#{Solution.published.count} published, #{Solution.count - Solution.published.count} unpublished)"
