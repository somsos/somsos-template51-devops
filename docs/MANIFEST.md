# MANIFEST

1. Your local machine has two environments, localhost and local-container:
    - **localhost**: Works as always, for example, using `mvn sprinf-boot:run` to
      deploy the backend or `npm run start` to start the frontend. The idea of
      using this one is to develop new features quickly.
    - **local-container**: In this case we use our docker local installation to
      run the application, with the end of test our application from a
      containerized perspective, because stage and production environments
      work this way.

2. We use the project in a recursive way, e.g., if we want to deploy/migrate the
   database, we create a copy of devops and database projects in Database-deploy,
   and we run the 

4. Whe have two ways to deploy in our `local-container` environment:
   - Getting in the `workspace/[action] via host-terminal` and run the
     scripts, where actions is what we want to do, e.g.
     workspace/Backend-Deploy, here we have 3 scripts, witch are necesary to
     deploy in out local-container environment.
   - Using `Jenkins`, this one it's going to run the same scripts in the pipelines.
   - **Difference**: when we run the scripts using the `host-terminal` these
     ones are going to copy the content 