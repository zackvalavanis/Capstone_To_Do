Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000', 
            'http://localhost:5173', 
            'https://capstone-to-do-frontend-2t2p281in-zackvalavanis-projects.vercel.app'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end
