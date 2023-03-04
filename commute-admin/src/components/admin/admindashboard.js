// import axios from "axios";
// import { useEffect, useState } from "react";
// import { Link } from "react-router-dom";
// import { NavLink } from 'react-router-dom';
// import  '../css/adminheader.css'

import React, {useState} from "react";
import AdminHeader from "./adminheader";


// JavaScript
// src/AddTask.js

import { db } from "../../firebase";
import {collection, addDoc, Timestamp} from 'firebase/firestore';

const handleSubmit = async (e) => {
    e.preventDefault()
    try {
      await addDoc(collection(db, 'tasks'), {
        title: "hi",
        description: "description",
        completed: "false",
        created: Timestamp.now()
      })
    
    } catch (err) {
      alert(err)
    }
  }




const AdminDashboard =()=>{

    return(
    <>
    <AdminHeader/>

<div className="container content-wrapper mt-3">
                        <div className="row">
                            <div className="col-md-12 grid-margin">
                                <div className="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 className="font-weight-bold navbar-brand brand-logo">Rider Request List</h4>
                                    </div>
                                    <div>
                                        <button to="#" className="btn btn-success btn-icon-text btn-rounded">
                                        Add New Rider</button>
                                    </div>
                                </div>
                            </div>
                            <div className="col-md-12 grid-margin stretch-card mt-2" >
                                <div className="card position-relative">
                                    <div className="card-body">
                                        <h4 className="card-title font-weight-bold">List of Riders</h4> 
                                        <div className="table-responsive">
                                            <table className="table table-hover table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Profile Pic</th>
                                                        <th>Rider Name</th>
                                                        <th>Vehicle Category</th>
                                                        <th>Supporting Document</th>
                                                        <th>Changes</th>
                                                        <th>Action</th>
                                                        
                                                    </tr>   
                                                </thead>

                                                <thead>
                                                    <tr>
                                                        <td>Image</td>
                                                        <td>Ram Lal</td>
                                                        <td>Scooter</td>
                                                        <td>Document Recieved.</td>
                                                        <td><button 
                                                        className="btn btn-primary btn-fw">Verify </button></td>
                                                        <td><button 
                                                        // onClick={this.deleteProduct} 
                                                        className="btn btn-danger btn-fw">Remove</button></td>            
                                                    </tr>   
                                                </thead>

                                                <thead>
                                                    <tr>
                                                        <td>Image</td>
                                                        <td>Shyam</td>   
                                                        <td>Bike</td>
                                                        <td>Document Recieved.</td>
                                                        <td><button 
                                                        // onClick={this.deleteProduct} 
                                                        className="btn btn-primary btn-fw">Verify </button></td>
                                                        <td><button 
                                                        // onClick={this.deleteProduct} 
                                                        className="btn btn-danger btn-fw">Remove</button></td>            
                                                    </tr>   
                                                </thead>      
                                            </table>
                                            
                                        </div>        
                                    </div>
                                </div>
                            </div>
                        </div>    
                </div>


        <div>
            <form onSubmit={handleSubmit}>
                <label> Enter message </label>
                <input type="text" />
                <button type="submit">Save</button>
            </form>
        </div>


        




  </>
   )
};
export default  AdminDashboard;