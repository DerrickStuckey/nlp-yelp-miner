
import urllib2
from bs4 import BeautifulSoup
import csv

kapnos_url = "http://www.yelp.com/biz/kapnos-taverna-arlington?sort_by=date_desc"
pollo_url = "http://www.yelp.com/biz/el-pollo-rico-arlington?sort_by=date_desc"
bonchon_url = "http://www.yelp.com/biz/bonchon-arlington-arlington?sort_by=date_desc"
max_iters = 100
revs_per_page = 40

def get_base_soup(url, start=0):
    # baseQuery = url
    # if start:
    baseQuery = url + "&start=" + str(start)
    print "baseQuery = ", baseQuery
    baseResponse = urllib2.urlopen(baseQuery)
    baseSoup = BeautifulSoup(baseResponse)
    return baseSoup

def scrape_reviews(url):
    reviews = []
    i = 0
    while(i < max_iters):
        print "i = ", i
        soup = get_base_soup(url, start=(i*revs_per_page))
        cur_reviews = soup.findAll(name='p', attrs={'itemprop':'description'})
        print "num reviews: ", len(cur_reviews)
        if (len(cur_reviews) == 0):
            "breaking"
            break
        reviews = reviews + cur_reviews
        i = i + 1
    #extract text and ascii-encode, ignoring errors, for each review
    print "total reviews: ", len(reviews)
    return [r.text.encode('ascii', 'ignore') for r in reviews]

def save_to_csv(texts, filename):
    with open(filename, 'wb') as csvfile:
        csvwriter = csv.writer(csvfile, delimiter='|', quotechar='%', escapechar="\\", quoting=csv.QUOTE_NONE)
        csvwriter.writerow(['content'])
        for text in texts:
            csvwriter.writerow([text])
        #csvwriter.writerow(['Spam'] * 5 + ['Baked Beans'])

def read_from_csv(filename):
    with open(filename, 'rb') as csvfile:
        reader = csv.DictReader(csvfile, delimiter="|", quotechar='%', escapechar="\\", quoting=csv.QUOTE_NONE)
        return [row['content'] for row in reader]

# revs = scrape_reviews(kapnos_url)
# save_to_csv(revs,"kapnos_reviews.csv")

# revs = read_from_csv("kapnos_reviews.csv")
# print "revs length: ", len(revs)

# pollo_revs = scrape_reviews(pollo_url)
# save_to_csv(pollo_revs, "pollo_revs.csv")

# pollo_revs = read_from_csv("pollo_revs.csv")
# print len(pollo_revs)
# print pollo_revs[0]
# print pollo_revs[len(pollo_revs)-1]

bonchon_revs = scrape_reviews(bonchon_url)
save_to_csv(bonchon_revs, "bonchon_revs.csv")