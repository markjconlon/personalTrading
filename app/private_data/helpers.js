// Time to get private data if using wealthsimple this will get you activity info
// note you will have to scroll and click load more
// works for all activities
let nl = document.querySelectorAll("div.kxhtWX");
let myArray = Array.from(nl);
let stringRecords = myArray.map(function(item){
    return item.children[0].innerText + item.children[1].innerText
})

// to expand to get activit details for trades you can expand all with
document.querySelectorAll("button").forEach((ele) => (ele.click()));

// grab the details
let activityDetails = document.querySelectorAll("div.sc-aea3a69c-0.sc-8f90d67c-1.clRVau.eLHnMA")
let activityDetailsArray = Array.from(activityDetails);
let adStringRecords = activityDetailsArray.map(function(item){
    return item.innerText;
})