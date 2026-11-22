const Trip=require('../models/Trip');
exports.list=async(req,res,next)=>{try{const trips=await Trip.all();res.render('dashboard',{title:'Trip dashboard',trips});}catch(err){next(err);}};
exports.detail=async(req,res,next)=>{try{const id=Number(req.params.id);if(!Number.isSafeInteger(id)||id<1)return res.status(400).send('Invalid trip ID');const trip=await Trip.find(id);if(!trip)return res.status(404).send('Trip not found');res.render('trip',{title:trip.title,trip});}catch(err){next(err);}};
