FROM saagie/shiny4saagie
# Alternatively, use saagie/shiny4saagie-supercharged with pre-installed dependencies, or build your own
# intermediate layer that suits your needs
 
# Install R packages required by your Shiny app
RUN R -e 'install.packages(c("markdown", "shiny"), repos="http://cloud.r-project.org")'
 
# Copy your Shiny app to /srv/shiny-server/myapp
COPY shiny-info /srv/shiny-server/myapp
 
# Launch Shiny Server
CMD ["/usr/bin/shiny-server.sh"]