import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { hashPassword } from "@/lib/auth";

export const dynamic = 'force-dynamic';

// GET: Fetch Single Staff Member
export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;

        const staff = await prisma.user.findUnique({
            where: { id },
            include: {
                FacultyProfile: {
                    include: {
                        Project: true
                    }
                }
            }
        });

        if (!staff || (staff.role !== 'FACULTY' && staff.role !== 'ADMIN')) {
            return NextResponse.json({ error: "Staff member not found" }, { status: 404 });
        }

        return NextResponse.json(staff);
    } catch (error) {
        console.error("Error fetching staff:", error);
        return NextResponse.json({ error: "Failed to fetch staff data" }, { status: 500 });
    }
}

// PUT: Update Staff Member
export async function PUT(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;
        const body = await request.json();
        const { name, email, department, role, password, isActive } = body;

        const updateData: any = {
            fullName: name,
            email,
            isActive: isActive !== undefined ? isActive : undefined,
        };

        if (password && password.trim() !== "") {
            updateData.password = await hashPassword(password);
        }

        if (role === 'ADMIN' || role === 'FACULTY') {
            updateData.role = role;
        }

        // Handle FacultyProfile update if it exists or if role is FACULTY
        const user = await prisma.user.findUnique({ where: { id }, include: { FacultyProfile: true } });

        if (user?.role === 'FACULTY' || role === 'FACULTY') {
            updateData.FacultyProfile = {
                upsert: {
                    create: {
                        department: department || "General",
                        designation: role || "FACULTY",
                        expertise: []
                    },
                    update: {
                        department: department,
                        designation: role
                    }
                }
            };
        }

        const updatedUser = await prisma.user.update({
            where: { id },
            data: updateData,
            include: { FacultyProfile: true }
        });

        return NextResponse.json(updatedUser);
    } catch (error) {
        console.error("Error updating staff:", error);
        return NextResponse.json({ error: "Failed to update staff member" }, { status: 500 });
    }
}

// DELETE: Remove Staff Member
export async function DELETE(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;
        await prisma.user.delete({
            where: { id }
        });
        return NextResponse.json({ message: "Staff member deleted" });
    } catch (error) {
        console.error("Error deleting staff:", error);
        return NextResponse.json({ error: "Failed to delete staff member" }, { status: 500 });
    }
}
