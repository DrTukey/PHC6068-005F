![alt text](https://github.com/DrTukey/PHC6068-005F/blob/develop/images/covid.jpg?raw=true)

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


This package can pull COVID-19 daily data from CDC. 


Install the package by running /inst/create_package.R.



Usage examples:

df_filtered_1 <- pull_covid_data("2020-09-30", "2020-10-30")

df_filtered_2 <- pull_covid_data(start_date="2020-09-30", 
                                 end_date="2020-10-30", 
                                 limit=100)

df_filtered_3 <- pull_covid_data(start_date="2020-01-01", 
                                 end_date="2020-10-30",
                                 states=c("FL", "TX", "CA"),
                                 fields=c("state", "new_case", "new_death", 
                                          "tot_cases", "tot_death", 
                                          "submission_date"),
                                 limit=100)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/DrTukey/PHC6068-005F/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/DrTukey/PHC6068-005F/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/DrTukey/PHC6068-005F/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
