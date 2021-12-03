-- Finding uncategorized.
SELECT i.itemID, idv.value
FROM items i
JOIN itemData id ON id.itemID = i.itemID
JOIN itemTypes it ON it.itemTypeID = i.itemTypeID
JOIN itemDataValues idv ON idv.valueID = id.valueID
WHERE
    fieldID = 1 -- This is "title"
    AND it.itemTypeID <> 2 -- We don't want attachments.
    AND i.itemID NOT IN (SELECT itemID FROM collectionItems);
