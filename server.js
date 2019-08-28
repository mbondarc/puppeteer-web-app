'use strict';
const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
const host = '0.0.0.0';
const port = process.env.port || 8000;

//ignore favicon request
app.use(function (req, res, next) {
    if (req.originalUrl && req.originalUrl.split("/").pop() === 'favicon.ico') {
        return res.sendStatus(204);
    }
    return next();
});

app.get('/', async (req, res, next) => {
    try {
        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        await page.goto('https://example.com');
        let content = await page.content();
        await browser.close();
		
        console.log('Success!');
        res.status(200).send(content);
        next();
    }
    catch (err) {
        console.log(err);
        res.status(500).send(err);
        next(err);
    }
});

app.listen(port, host, () => console.log(`app listening on port ${port}!`));
