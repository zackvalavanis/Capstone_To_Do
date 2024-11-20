Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000',  # For local development
            'http://localhost:5173',  # If using Vite
            'https://capstone-to-do-frontend-dge7vhc3n-zackvalavanis-projects.vercel.app'  # Vercel frontend URL

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end
