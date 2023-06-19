# Simple-Form
# Shiny Form with MongoDB Integration

This is a Shiny web application that allows users to fill out a form with their personal information and save the data to a MongoDB database. The application also provides a results tab to view the submitted form data and a charts tab to visualize the data using various charts.

## Requirements

- R programming language
- Shiny package
- mongolite package
- plotly package
- shinythemes package

## Installation

1. Clone or download the project repository.
2. Open the R script `app.R` in RStudio or any other R development environment.
3. Install the required packages using the following command in the R console:install.packages(c("shiny", "mongolite", "plotly", "shinythemes"))
5. Run the Shiny app by clicking the "Run App" button in RStudio, or by running the following command in the R console:shiny::runApp("path_to_the_project_directory")

Replace "path_to_the_project_directory" with the actual path to the project directory on your machine.

## Usage

1. Once the Shiny app is running, open your web browser and go to the provided URL.
2. Navigate through the tabs to fill out the form in the first tab, view the form data in the second tab, and explore the charts in the third tab.
3. In the first tab, enter your name, email, phone number, select a status, choose a region (Brazilian state code), and specify a salary. Click the "Submit" button to save the form data to the MongoDB database.
4. In the second tab, you can view the submitted form data in a table format.
5. In the third tab, you will find a funnel chart showing the distribution of form data by status, a pie chart showing the distribution by region, and a histogram displaying the count of registrations over time.
6. Explore the charts by interacting with them (zooming, hovering, etc.) to gain insights into the data.

## Data Storage

- The form data is saved to a MongoDB database using the `mongolite` package.
- The MongoDB connection details can be configured in the `mongo_conn` object in the server section of the `app.R` script.

## Credits

- The Shiny web application template is based on the `shinythemes` package with the "slate" theme.
- The charts are generated using the `plotly` package, which provides interactive and visually appealing visualizations.


