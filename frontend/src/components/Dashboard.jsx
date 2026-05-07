import React, { useState, useEffect } from 'react';
import axios from 'axios';

const Dashboard = ({ apiBase }) => {
  const [stats, setStats] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const res = await axios.get(`${apiBase}/dashboard-stats`);
        setStats(res.data.data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
  }, [apiBase]);

  if (loading) return <div>Loading...</div>;

  return (
    <div>
      <h2>Placement Analytics View</h2>
      <p className="stat-title" style={{marginBottom: '2rem'}}>Real-time data aggregated using SQL functions and views.</p>
      
      {stats.length === 0 ? (
        <div className="card">No data available. Have you run the database initialization scripts?</div>
      ) : (
        <div className="stats-grid">
          {stats.map((dept, idx) => (
            <div key={idx} className="card stat-card">
              <div className="stat-title">{dept.dept_name}</div>
              <div className="stat-value">{dept.placement_percentage}% Placed</div>
              <div style={{color: 'var(--text-secondary)', fontSize: '0.875rem', marginTop: '0.5rem'}}>
                Students: {dept.total_students} | Placed: {dept.placed_students}
                <br/>
                Highest Package: {dept.highest_package_lpa} LPA
                <br/>
                Avg CGPA: {Number(dept.average_cgpa).toFixed(2)}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Dashboard;
