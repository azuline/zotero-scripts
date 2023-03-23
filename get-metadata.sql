-- The canonical dataset of item metadata for ease-of-querying.

WITH fieldData AS (
    SELECT id.itemID, f.fieldName, idv.value
    FROM fields f
    JOIN itemData id ON id.fieldID = f.fieldID
    JOIN itemDataValues idv ON idv.valueID = id.valueID
    WHERE f.fieldName IN (
        'title'
      , 'date'
      , 'url'
      , 'ISBN'
      , 'DOI'
      , 'ISSN'
    )
),
aggCreators AS (
    SELECT 
        t.itemID
      , GROUP_CONCAT(t.name, '|') AS value
    FROM (
        SELECT
            ic.itemID
            , c.firstName || ' ' || c.lastName AS name
        FROM itemCreators ic
        JOIN creators c ON c.creatorID = ic.creatorID
        ORDER BY ic.orderIndex
    ) AS t
    GROUP BY t.itemID
),
rsc AS (
    SELECT
        items.key
      , items.dateAdded date_added
      , doi.value
      , issn.value
      , isbn.value
      , url.value
      , title.value
      , authors.value
      , SUBSTRING(year.value, 1, 4)
    FROM items 
    LEFT JOIN fieldData title ON title.itemID = items.itemID AND title.fieldName = 'title'
    LEFT JOIN fieldData doi ON doi.itemID = items.itemID AND doi.fieldName = 'DOI'
    LEFT JOIN fieldData issn ON issn.itemID = items.itemID AND issn.fieldName = 'ISSN'
    LEFT JOIN fieldData isbn ON isbn.itemID = items.itemID AND isbn.fieldName = 'ISBN'
    LEFT JOIN fieldData url ON url.itemID = items.itemID AND url.fieldName = 'url'
    LEFT JOIN fieldData year ON year.itemID = items.itemID AND year.fieldName = 'date'
    LEFT JOIN aggCreators authors ON authors.itemID = items.itemID
)
/* SELECT * FROM rsc WHERE key = '4MMA8B7E'; */
SELECT * FROM rsc LIMIT 20;
