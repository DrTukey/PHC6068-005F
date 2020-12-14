<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/DrTukey/PHC6068-005F">
    <img src="https://github.com/DrTukey/PHC6068-005F/blob/develop/images/covid.jpg?raw=true" alt="Logo" width="800" height="450">
  </a>
  
  <h3 align="center">COVID DATA TRENDER</h3>

  <p align="center">
    The COVID data trender for everyone!
  </p>

</p>

<!-- ABOUT THE PROJECT -->
## About COVID TRENDER


There are many great R projects on GitHub, however, this project ours and that means it's the best to us. We want COVID data to be accessible to everyone and interpretable by anyone who is interested.

This project:
* Allows you to pull COVID data from the CDC in a flexible manner
* Generates plots of historic data representing cases and deaths by state
* Displays trended data for future COVID impacts

There are many other COVID packages and this package will supplement those with new analysis and new visualizations, but will also learn from best practices across many domains of knowledge.

### Built With

This package is built on the R programming language and utilizes public data available from the CDC.
* [R Studio](https://rstudio.com/)
* [CDC](https://www.cdc.gov/)




<!-- INSTALLATION -->
## Installation

1. Install the package
   ```sh
   git clone https://github.com/DrTukey/PHC6068-005F.git
   ```



<!-- USAGE -->
## Usage

1. Retrieve COVID data
   ```sh
   covid <- pull_covid_data("2020-09-30", "2020-10-30")
   ```
2. Create historic charts
   ```sh
   covid_cases_graph("2020-03-30", "2020-08-30",  per100k = TRUE)
   ```
3. Generate future trends
   ```sh
   covid_ts_forecast(start_date='2020-01-01', fvar="new_case", state.filter=c("MA","CA"), pred.days = 30)
   ```




<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/CovidFeature`)
3. Commit your Changes (`git commit -m 'Solving Covid'`)
4. Push to the Branch (`git push origin feature/CovidFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the GNU GPL License. See `LICENSE` for more information.



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/DrTukey/PHC6068-005F/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/DrTukey/PHC6068-005F/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/DrTukey/PHC6068-005F/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/DrTukey/PHC6068-005F/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/DrTukey/PHC6068-005F/blob/develop/LICENSE.txt
