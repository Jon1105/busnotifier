# Todo
- [ ] Add daily notification for hk cases
- [ ] Use google maps api
- [ ] [gov](https://data.gov.hk/en-data/dataset/hk-dh-chpsebcddr-novel-infectious-agent) api to show location of cases
- [ ] Bug: Fix deaths scale
- [ ] Change countries.dart to json file
- [ ] Create interchangeable themes
- [ ] Add multiple stop functionality
- [ ] Use [tootltip](https://www.youtube.com/watch?v=EeEfD5fI-5Q)
- [ ] Show Dropdowns over case list to choose which fields to show
- [ ] Preserve current country when switching between pages in PageView
- [ ] Check if data is corect in HK cases info
- [ ] Complete filter functionality for cases info (dates / days ago, ...)
- [ ] Why some cases have duplicates (e.g. case 3397 - 3368)
- [ ] show map in district info
- [ ] add district numbers next to each district
- [ ] Add an *all countries* dashboard

<br/>

- [x] Optimise Loading of data from owid by saving in memory for 1 day (Time of update ~= 17:15 HK)
      TimeOfDay.utc()  
      ~~Use [smaller data set](https://covid.ourworldindata.org/data/ecdc/full_data.csv)~~
- [x] fix shadow on dropdowns for districts
- [x] Make filter function for cases info
- [x] Wrap Reminders and Covid Apps in PageView