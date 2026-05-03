'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { getRequests, getAdminStats, getAdminUsers, getAdminRequests, updateRequestStatus } from '@/services/api';
import toast from 'react-hot-toast';

export default function DashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [requests, setRequests] = useState([]);
  const [stats, setStats] = useState<any>(null);
  const [users, setUsers] = useState([]);
  const [allRequests, setAllRequests] = useState([]);
  const [activeTab, setActiveTab] = useState('requests');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const userStr = localStorage.getItem('user');
    if (!userStr) {
      router.push('/');
      return;
    }
    const parsed = JSON.parse(userStr);
    setUser(parsed);
    loadData(parsed);
  }, []);

  const loadData = async (currentUser?: any) => {
    const u = currentUser ?? user;
    try {
      const [requestsRes] = await Promise.all([getRequests()]);
      setRequests(requestsRes.data);
      
      if (u?.role === 'admin') {
        const [statsRes, usersRes, allReqsRes] = await Promise.all([
          getAdminStats(), getAdminUsers(), getAdminRequests()
        ]);
        setStats(statsRes.data.data);
        setUsers(usersRes.data.data);
        setAllRequests(allReqsRes.data.data);
      }
    } catch (error) {
      toast.error('Failed to load data');
    } finally {
      setLoading(false);
    }
  };

  const handleStatusUpdate = async (id: string, status: string) => {
    try {
      await updateRequestStatus(id, status);
      toast.success('Status updated');
      loadData();
    } catch (error) {
      toast.error('Failed to update status');
    }
  };

  const handleLogout = () => {
    localStorage.clear();
    router.push('/');
  };

  const getStatusColor = (status: string) => {
    switch(status) {
      case 'pending': return 'bg-yellow-100 text-yellow-800';
      case 'in_progress': return 'bg-blue-100 text-blue-800';
      case 'completed': return 'bg-green-100 text-green-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  if (loading) return <div className="min-h-screen flex items-center justify-center">Loading...</div>;

  if (user?.role === 'admin') {
    return (
      <div className="min-h-screen bg-gray-100">
        <nav className="bg-white shadow-sm border-b">
          <div className="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
            <h1 className="text-xl font-bold text-gray-800">Admin Panel - Zigurat</h1>
            <button onClick={handleLogout} className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">Logout</button>
          </div>
        </nav>

        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="grid grid-cols-4 gap-4 mb-6">
            <div className="bg-white rounded-lg p-4 shadow"><div className="text-2xl font-bold">{stats?.totalUsers || 0}</div><div className="text-gray-500">Total Users</div></div>
            <div className="bg-white rounded-lg p-4 shadow"><div className="text-2xl font-bold">{stats?.totalRequests || 0}</div><div className="text-gray-500">Total Requests</div></div>
            <div className="bg-white rounded-lg p-4 shadow"><div className="text-2xl font-bold text-yellow-600">{stats?.pendingRequests || 0}</div><div className="text-gray-500">Pending</div></div>
            <div className="bg-white rounded-lg p-4 shadow"><div className="text-2xl font-bold text-green-600">{stats?.completedRequests || 0}</div><div className="text-gray-500">Completed</div></div>
          </div>

          <div className="bg-white rounded-lg shadow">
            <div className="border-b flex">
              <button onClick={() => setActiveTab('requests')} className={`px-6 py-3 ${activeTab === 'requests' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-gray-500'}`}>Requests</button>
              <button onClick={() => setActiveTab('users')} className={`px-6 py-3 ${activeTab === 'users' ? 'border-b-2 border-blue-500 text-blue-600' : 'text-gray-500'}`}>Users</button>
            </div>

            <div className="p-4">
              {activeTab === 'requests' && (
                <div className="space-y-3">
                  {allRequests.map((req: any) => (
                    <div key={req.id} className="border rounded-lg p-4">
                      <div className="flex justify-between items-start">
                        <div><div className="font-medium">{req.requestNumber}</div><div className="text-sm text-gray-500">{req.type} - {req.user?.fullName}</div></div>
                        <select value={req.status} onChange={(e) => handleStatusUpdate(req.id, e.target.value)} className={`px-3 py-1 rounded-full text-sm ${getStatusColor(req.status)} border-0`}>
                          <option value="pending">Pending</option><option value="in_progress">In Progress</option><option value="completed">Completed</option>
                        </select>
                      </div>
                    </div>
                  ))}
                </div>
              )}
              {activeTab === 'users' && (
                <div className="space-y-3">
                  {users.map((user: any) => (
                    <div key={user.id} className="border rounded-lg p-4 flex justify-between items-center">
                      <div><div className="font-medium">{user.fullName}</div><div className="text-sm text-gray-500">{user.email}</div></div>
                      <span className={`px-3 py-1 rounded-full text-sm ${user.role === 'admin' ? 'bg-purple-100 text-purple-800' : 'bg-blue-100 text-blue-800'}`}>{user.role}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
          <h1 className="text-xl font-bold text-gray-800">Student Dashboard</h1>
          <button onClick={handleLogout} className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">Logout</button>
        </div>
      </nav>

      <div className="max-w-4xl mx-auto px-4 py-6">
        <div className="bg-gradient-to-r from-blue-500 to-blue-600 rounded-lg p-6 text-white mb-6">
          <h2 className="text-2xl font-bold">Welcome, {user?.fullName}!</h2>
          <p className="mt-2">Track your translation requests and visa applications</p>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex justify-between items-center mb-4"><h3 className="text-lg font-semibold">My Requests</h3><button className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">+ New Request</button></div>
          {requests.length === 0 ? <p className="text-gray-500 text-center py-8">No requests yet</p> : requests.map((req: any) => (
            <div key={req.id} className="border rounded-lg p-4 mb-3">
              <div className="flex justify-between items-center"><div><div className="font-medium">{req.requestNumber}</div><div className="text-sm text-gray-500">{req.type} - {new Date(req.createdAt).toLocaleDateString()}</div></div><span className={`px-3 py-1 rounded-full text-sm ${getStatusColor(req.status)}`}>{req.status}</span></div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
