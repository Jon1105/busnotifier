# Todo
- [ ]  ***iOS***
- [ ] Add daily notification for hk cases
- [ ] Use google maps api
- [ ] [gov](https://data.gov.hk/en-data/dataset/hk-dh-chpsebcddr-novel-infectious-agent) api to show location of cases
- [ ] Bug: Fix deaths scale
- [ ] Change countries.dart to json file
- [ ] Create interchangeable themes
- [ ] Add multiple stop functionality
- [ ] Preserve current country when switching between pages in PageView
- [ ] Check if data is corect in HK cases info
- [ ] Complete filter functionality for cases info (dates / days ago, ...)
- [ ]  ?? Add an *all countries* dashboard
- [ ]  App Icon

##### Completed

- [x] Fix onset Date
- [x] Why some cases have duplicates (e.g. case 3397 - 3368)
- [x] Show Dropdowns over case list to choose which fields to show
- [x] Use [tootltip](https://www.youtube.com/watch?v=EeEfD5fI-5Q)
- [x] show map in district info
- [x] add district numbers next to each district
- [x] Optimise Loading of data from owid by saving in memory for 1 day (Time of update ~= 17:15 HK)
      TimeOfDay.utc()  
      ~~Use [smaller data set](https://covid.ourworldindata.org/data/ecdc/full_data.csv)~~
- [x] fix shadow on dropdowns for districts
- [x] Make filter function for cases info
- [x] Wrap Reminders and Covid Apps in PageView