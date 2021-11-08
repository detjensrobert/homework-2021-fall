# WIC: Individual Contribution

## Robert Detjens

---

### Process Flows

![General overview](../images/overview.png)

![GitHub Image Build Pipeline](../images/deliverable-3.png)

![Pipeline Details](../images/gh-build-details.png)

\pagebreak

### User Stories

As a user of the deployment service, I want my application to be built quickly so that I can rapidly develop my
application and not wait on the build service.

As a user of the deployment service, I want my applications to be built correctly according the the rules I set so that
I know the application works as intended.

As a user of the deployment service, I want my applications to be built reproducibly so that the built image is the same
as would be created in a local dev environment.

As a developer, I want the deployment pipeline to be simple so that it can be easily worked on and maintained with new
features.

As the project partner, I want a working pipeline so that the full product can be delivered.

As the end user of a deployed project, I want the container to be built correctly so that the application is functional.

### Personal Iteration Plan

Parts of this work are blocked on the Kubernetes install being functional. Research on how to implement this has been
completed, and the initial parts of the build script are not blocking on any other parts of the project. The latter part
of the deployment pipeline is blocking on the finalization of the K8S configuration template, as that information needs
to be encoded to configure the application when handing the built image off to Kubernetes.

The initial portion of the project -- the manual repo onboarding and build script -- should be on track for completion
by the end of the term. Container image handoff needs to be coordinated with the second half of the pipeline, which will
push the shipping date for that into Winter term.

I have experience working with Docker and containerizing applications, so I expect to help the rest of my team in
researching how to use Docker. In the time following the initial part of the build script, I will be able to help the
Kubernetes image onboarding pipeline team with their portion of the pipeline.

### Solution Architecture

Our team will be working on the project in 5 discrete parts in order to maximize available time and share the work of
managing parts of the pipeline between each team member. Most of our components are easily modularized, however some
depend on each other and will require each component team to coordinate solutions where their domains overlap.

The repo importing pipeline script will use the following tools:

- Git to fetch the repository source from the provided link
- Docker to build the application container from a Dockerfile in the repository
- Bash shell to prototype the script in
- Python to write the finalized script

### List of Terms

*Docker*
: A containerization platform that packages software in a lightweight, isolated, and portable environment called a
container. <https://www.docker.com/>

*Kubernetes*
: An open-source container-orchestration system for automating computer application development, scaling, and
  management. <https://kubernetes.io/>

*Pipeline*
: A set of automated processes that allow developers to reliably and efficiently compile, build, and deploy their code
  to their production compute platforms.

*Container*
: A fully-contained application that bundles all of its dependencies in one package and can be deployed easily

*Repository*
: A hosted version of source code tracked via a version control program such as Git
