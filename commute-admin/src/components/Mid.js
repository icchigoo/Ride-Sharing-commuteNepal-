import { Route, Routes } from "react-router-dom";
import AdminDashboard from "./admin/admindashboard"




const Mid=()=>{
    return(
        <Routes>
            {/* <Route path="/login" element={<Login/>}></Route> */}
            <Route path="/" element={<AdminDashboard/>}></Route>
            
        </Routes>
    )
}
export default Mid;